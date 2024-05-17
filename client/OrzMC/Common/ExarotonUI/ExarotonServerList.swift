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
                    ExarotonServerItem(server: server)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill()
                        .foregroundStyle(Color.teal)
                        .padding([.horizontal], 8)
                )
            }
        }
        .listStyle(.plain)
        .listRowSpacing(10)
        .navigationTitle("Exaroton")
        .navigationBarTitleDisplayMode(.automatic)
        .task {
            await model.fetchServers()
        }
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(model.isHttpLoading ? 1 : 0)
                .offset(y: -30)
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

struct ExarotonServerItem: View {
    @State var model = ExarotonServerModel()

    let server: ServerInfo

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let name = server.name {
                    Text(name)
                        .font(.headline)
                }
                if let id = server.id {
                    Text(id)
                        .font(.caption)
                }
                if let detail = server.detail {
                    Text(detail)
                        .font(.callout)
                }
            }
            Spacer()

            if let statusConfig = server.serverStatusConfig {
                ServerStatusView(config: statusConfig)
                    .frame(width: 30, height: 30)
            }
        }
        .task {
            
        }
    }
}

struct ServerStatusView: View {
    let config: ServerStatusConfig
    var body: some View {
        Button {

        } label: {
            Image(systemName: config.0)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .foregroundStyle(config.1)
        }
    }
}
