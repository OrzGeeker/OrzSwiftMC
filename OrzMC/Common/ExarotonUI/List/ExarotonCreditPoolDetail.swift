//
//  ExarotonCreditPoolDetail.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import SwiftUI

struct ExarotonCreditPoolDetail: View {
    @Environment(ExarotonServerModel.self) var model
    @State var creditPool: ExarotonCreditPool
    @State private var members: [ExarotonCreditMember]?
    @State private var servers: [ExarotonServer]?
    @State private var isLoading = false
    var body: some View {
        List {
            Section(creditPool.name ?? "") {
                HStack {
                    Spacer()
                    ExarotonCreditView(credits: creditPool.credits)
                        .padding([.top], 10)
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
            if let members {
                Section("Members") {
                    ForEach(members) { member in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(member.name ?? "")
                                Spacer()
                                ExarotonCreditView(credits: member.credits)
                                    .frame(height: 20)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            if let servers {
                Section("Servers") {
                    ForEach(servers) { server in
                        ExarotonServerView(server: server)
                            .onTapGesture {
                                model.path.append(server)
                            }
                    }
                }
            }
        }
        .task {
            await fetchDataWithLoading()
        }
        .navigationTitle("Credit Pool Detail")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(isLoading ? 1 : 0)
        }
        .refreshable {
            await fetchData()
        }
        .toolbar {
#if os(macOS)
            Button("Refresh Page", systemImage: "arrow.circlepath") {
                Task {
                    await fetchDataWithLoading()
                }
            }
            .keyboardShortcut(.init(.init("r")), modifiers: .command)
#endif
        }
    }

    func fetchDataWithLoading() async {
        isLoading = true
        await fetchData()
        isLoading = false
    }

    func fetchData() async {
        let info = await model.fetchCreditPoolInfo(creditPool)
        guard let info
        else {

            return
        }
        let (pool, members, servers) = info
        if let pool {
            self.creditPool = pool
        }
        self.members = members
        self.servers = servers
    }
}
