//
//  ExarotonServerList.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI

struct ExarotonServerList: View {
    @Environment(ExarotonServerModel.self) var model
    @State var token: String
    @State private var isLoading = false
    @State private var showTokenInput = false
    var body: some View {
        List() {
            if !model.servers.isEmpty {
                Section("Servers") {
                    ForEach(model.servers, id: \.id) { server in
                        ExarotonServerView(server: server)
                            .onTapGesture {
                                model.path.append(server)
                            }
                    }
                }
            }
            if !model.creditPools.isEmpty {
                Section("Credit Pools") {
                    ForEach(model.creditPools) { creditPool in
                        ExarotonCreditPoolView(creditPool: creditPool)
                            .onTapGesture {
                                model.path.append(creditPool)
                            }
                    }
                }
            }
        }
        .navigationTitle("Exaroton")
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
            ExarotonAccountTokenInputView(token: $token)
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
        .environment(model)
        .task {
            if model.token.isEmpty {
                showTokenInput = true
            } else {
                await startWork()
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
