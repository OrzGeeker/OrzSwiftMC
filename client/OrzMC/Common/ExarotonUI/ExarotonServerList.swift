//
//  ExarotonServerList.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI

struct ExarotonServerList: View {
    @State var model = ExarotonServerModel()
    var body: some View {
        List() {
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
        .listStyle(.plain)
        .navigationTitle("Exaroton")
#if os(iOS)
        .listRowSpacing(10)
        .navigationBarTitleDisplayMode(.automatic)
#endif
        .task {
            await model.fetchServers()
        }
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(model.isHttpLoading ? 1 : 0)
        }
        .toolbar {
            ToolbarItemGroup {
                Button(action: {
                    Task {
                        await model.fetchServers()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
            }
        }
    }

}
