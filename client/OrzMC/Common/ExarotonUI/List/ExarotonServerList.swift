//
//  ExarotonServerList.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI

struct ExarotonServerList: View {
    @State private var model = ExarotonServerModel()
    @State private var isLoading = false
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
            self.isLoading = true
            await fetchData()
            self.isLoading = false
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
