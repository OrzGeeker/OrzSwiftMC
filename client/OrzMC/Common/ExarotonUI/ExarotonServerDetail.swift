//
//  ExarotonServerDetail.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI

struct ExarotonServerDetail: View {

    @Environment(ExarotonServerModel.self) var model

    @State var server: ServerInfo

    var body: some View {
        @Bindable var model = model

        Form {

            Section("Basic") {

                if let motd = server.motd {
                    Text(motd)
                }
                if let serverId = server.id, model.readyServerID == serverId {
                    Text("On Ready: \(serverId)")
                }

                Text("Server: \(model.isConnected ? "connected" : "disconnected")")

                if let host = server.host, let port = server.port {
                    Text("\(host):\(port)")
                }
            }

            if let playerList = server.players?.list, !playerList.isEmpty {
                Section("Players") {
                    ForEach(playerList, id: \.self) { playerName in
                        Text(playerName)
                    }
                }
            }

            Section("Actions") {

                Button("Start Server") {
                    Task {
                        await model.startServer(serverId: server.id!)
                    }
                }

                Button("Stop Server") {
                    Task {
                        await model.stopServer(serverId: server.id!)
                    }
                }

                Button("Restart Server") {
                    Task {
                        await model.restartServer(serverId: server.id!)
                    }
                }
            }

        }
        .navigationTitle(server.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup {
                if let statusConfig = server.serverStatusConfig {
                    ServerStatusView(config: statusConfig)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .task {
            model.startConnect(for: server.id!)
        }
        .onDisappear {
            model.stopConnect()
        }
        .onReceive(model.statusChangedServer.publisher) { newStatusServer in
            guard let serverInfo = try? newStatusServer.serverInfo
            else {
                return
            }
            server = serverInfo
        }
    }
}
