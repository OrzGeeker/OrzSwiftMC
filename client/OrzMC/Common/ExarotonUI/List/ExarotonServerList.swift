//
//  ExarotonServerList.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI

struct ExarotonServerList: View {
    @State var token: String
    @State private var model = ExarotonServerModel()
    @State private var isLoading = false
    @State private var showTokenInput = false
    var body: some View {
        List() {
            if !model.servers.isEmpty {
                Section("Servers") {
                    ForEach(model.servers, id: \.id) { server in
                        NavigationLink {
                            ExarotonServerDetail(server: server)
                                .environment(model)
                        } label: {
                            ExarotonServerListItem(server: server)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill()
                                .foregroundStyle(Color("AccentColor", bundle: nil))
                                .padding([.horizontal], 8)
                        )
                    }
                }
            }
            if !model.creditPools.isEmpty {
                Section("Credit Pools") {
                    ForEach(model.creditPools) { creditPool in
                        NavigationLink {
                            ExarotonCreditPoolDetail(creditPool: creditPool)
                                .environment(model)
                        } label: {
                            ExarotonCreditPoolListItem(creditPool: creditPool)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Exaroton")
#if os(iOS)
        .listRowSpacing(10)
        .navigationBarTitleDisplayMode(.automatic)
#endif
        .task {
            if model.token.isEmpty {
                showTokenInput = true
            } else {
                await startWork()
            }
        }
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(isLoading ? 1 : 0)
        }
        .refreshable {
            await fetchData()
        }
        .sheet(isPresented: $showTokenInput) {
            if !token.isEmpty {
                model.token = token.trimmingCharacters(in: .whitespacesAndNewlines)
                token = ""
                Task {
                    await startWork()
                }
            }
        } content: {
            VStack(alignment: .trailing, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Input Account Token: ")
                        .font(.title)
                        .bold()
                    TextField("TOKEN", text: $token, axis: .vertical)
                        .frame(height: 80)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                VStack(alignment: .trailing) {
                    HStack(alignment: .center) {
                        Image("exaroton", bundle: nil)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .offset(y: 3)
                        Text("exaroton")
                            .font(.title)
                            .bold()
                    }
                    Text("by Aternos")
                        .font(.footnote)
                }
            }
            .frame(height: 100)
            .padding([.horizontal], 10)
        }
        .toolbar {
            ToolbarItemGroup {
                Button {
                    showTokenInput.toggle()
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
    }
    func startWork() async {
        self.isLoading = true
        await fetchData()
        self.isLoading = false
    }
    func fetchData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await model.fetchServers()
            }
            group.addTask {
                await model.fetchCreditPools()
            }
        }
    }
}
