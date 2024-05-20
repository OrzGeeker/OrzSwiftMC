//
//  ExarotonServerDetail.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import SwiftUI
import ExarotonWebSocket

struct ExarotonServerDetail: View {

    @Environment(ExarotonServerModel.self) var model

    @State var server: ExarotonServer

    @State private var networkOpacity: Double = 1

    var body: some View {

        @Bindable var model = model

        Form {

            if let motd = server.motd {
                Section("MOTD") {
                    Text(motd)
                }
            }

            if server.hasAddress {
                Section("Address") {
                    if let staticAddress = server.staticAddress {
                        Text("\(staticAddress)")
                            .onTapGesture {
                                staticAddress.copyToPasteboard()
                            }
                    }

                    if let dynamicAddress = server.dynamicAddress {
                        Text("\(dynamicAddress)")
                            .onTapGesture {
                                dynamicAddress.copyToPasteboard()
                            }
                    }
                }
            }

            if let playerList = server.players?.list, !playerList.isEmpty {
                Section("Players") {
                    ForEach(playerList, id: \.self) { playerName in
                        Text(playerName)
                    }
                }
            }


            if let serverStatus = server.serverStatus {

                Section("Actions") {

                    Button("Start Server") {
                        Task {
                            await model.startServer(serverId: server.id!)
                        }
                    }
                    .disabled(serverStatus != .OFFLINE)

                    Button("Stop Server") {
                        Task {
                            await model.stopServer(serverId: server.id!)
                        }
                    }
                    .disabled(serverStatus != .ONLINE)

                    Button("Restart Server") {
                        Task {
                            await model.restartServer(serverId: server.id!)
                        }
                    }
                    .disabled(serverStatus != .ONLINE)
                }
            }

            Text("Server: \(model.isConnected ? "connected" : "disconnected")")

            Section("Streams") {

                Button("start console") {
                    model.startStream(.console, data: ["tail": 10])
                }

                Button("send console command") {
                    model.sendConsoleCmd("say Hello")
                }

                Button("stop console") {
                    model.stopStream(.console)
                }

                if let console = model.consoleLine {
                    Text(console)
                        .lineLimit(nil)
                }
            }

            Section("Others") {
                ForEach([
                    StreamCategory.tick,
                    StreamCategory.stats,
                    StreamCategory.heap
                ], id: \.self) { streamCategory in
                    Button("start \(streamCategory.rawValue)") {
                        model.startStream(streamCategory)
                    }

                    Button("stop \(streamCategory.rawValue)") {
                        model.stopStream(streamCategory)
                    }
                }
            }
        }
        .navigationTitle(server.name ?? "")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .toolbar {
            ToolbarItemGroup {
                Image(systemName: "network")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundStyle(isWebSocketReady ? mainColor : dangerColor)
                    .frame(width: 30, height: 30)
                    .overlay {
                        Text("ws")
                            .font(.system(size: 8))
                            .bold()
                            .foregroundStyle(isWebSocketReady ? .pink : .teal)
                    }
                    .opacity(networkOpacity)
                    .animation(isWebSocketReady ? nil : .easeInOut(duration: 0.8).repeatForever(), value: networkOpacity)

                if let status = server.serverStatus {
                    ServerStatusView(status: status)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .task {
            model.startConnect(for: server.id!)
            networkOpacity = model.readyServerID == nil ? 0 : 1
        }
        .onChange(of: model.readyServerID) { oldValue, newValue in
            networkOpacity = newValue == nil ? 0 : 1
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

    var isWebSocketReady: Bool {
        return model.readyServerID != nil
    }
}
