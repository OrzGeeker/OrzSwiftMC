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
    @State private var loading = false
    var body: some View {
        List {
            HStack {
                Spacer()
                ExarotonCreditView(credits: creditPool.credits)
                    .padding([.top], 10)
                Spacer()
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
                    }
                }
            }
            if let servers {
                Section("Servers") {
                    ForEach(servers) { server in
                        ExarotonServerListItem(server: server)
                            .disabled(true)
                    }
                }
            }
        }
        .task {
            await fetchData()
        }
        .navigationTitle(creditPool.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(loading ? 1 : 0)
        }
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    Task {
                        await fetchData()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
            }
        }
    }

    func fetchData() async {
        loading = true
        let info = await model.fetchCreditPoolInfo(creditPool)
        guard let info
        else {
            loading = false
            return
        }
        loading = false
        let (pool, members, servers) = info
        if let pool {
            self.creditPool = pool
        }
        self.members = members
        self.servers = servers
    }
}
