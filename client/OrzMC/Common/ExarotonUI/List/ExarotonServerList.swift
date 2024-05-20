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
                        ExarotonServerListLinkItem(server: server)
                    }
                }
            }
            if !model.creditPools.isEmpty {
                Section("Credit Pools") {
                    ForEach(model.creditPools) { creditPool in
                        ExarotonCreditPoolListLinkItem(creditPool: creditPool)
                    }
                }
            }
        }
        .environment(model)
        .navigationTitle("Exaroton")
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
                ExarotonTradeMark()
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
}

extension ExarotonServerList {
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
