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

    @State private var wsServerReady: Bool = false

    @State private var networkOpacity: Double = 1

    @State private var serverRAM: Int32 = 0

    @State private var loading  = false

    var body: some View {

        @Bindable var model = model

        Form {

            Section("General") {
                ExarotonServerView(server: server)
            }

            if let playlist = server.players?.list, !playlist.isEmpty {
                Section("Playlist") {
                    ExarotonServerPlayList(playlist: playlist)
                }
            }

            if let serverStatus = server.serverStatus {

                Section("Actions - HTTP") {

                    if serverRAM > 0 {
                        Stepper("RAM: \(String(format: "%d", serverRAM)) GB",
                                value: $serverRAM,
                                in: 2...16,
                                step: 1
                        )
                        .disabled(loading || serverStatus != .OFFLINE)
                    }

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

                Text("Server: \(model.isConnected ? "connected" : "disconnected")")
                if serverStatus != .OFFLINE {
                    Section("Streams - WebSocket") {

                        if let console = model.consoleLine {
                            Text(console)
                                .font(.system(size: 8))
                                .lineLimit(nil)
                        }

                        Button("start console") {
                            model.startStream(.console, data: ["tail": 10])
                        }

                        Button("send console command") {
                            model.sendConsoleCmd("say Hello")
                        }

                        Button("stop console") {
                            model.stopStream(.console)
                        }

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
            }
        }
        .navigationTitle("Server Detail")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .toolbar {
            ToolbarItemGroup {
                Image(systemName: wsServerReady ? "checkmark.icloud.fill" : "icloud.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(wsServerReady ? mainColor : dangerColor)
                    .frame(width: 30, height: 30)
                    .opacity(networkOpacity)
                    .animation(wsServerReady ? nil : .easeInOut(duration: 0.8).repeatForever(), value: networkOpacity)
            }
        }
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(loading ? 1 : 0)
        }
        .task {
            model.startConnect(for: server.id!)
            wsServerReady = model.readyServerID != nil
            networkOpacity = wsServerReady ? 1 : 0
            if let ram = await model.getRAM(serverId: server.id!) {
                serverRAM = ram
            }
        }
        .onChange(of: model.readyServerID) { oldValue, newValue in
            wsServerReady = newValue != nil
            networkOpacity = wsServerReady ? 1 : 0
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
        .onChange(of: serverRAM, initial: false) { oldValue, newValue in
            guard let serverID = server.id
            else {
                return
            }
            Task {
                loading = true
                if let ram = await model.changeRAM(serverId: serverID, ramGB: newValue) {
                    serverRAM = ram
                }
                loading = false
            }
        }
    }
}

extension ExarotonServerDetail {
    func startSubscribeEvent() {
        if wsServerReady {
            [
                StreamCategory.console,
                StreamCategory.tick,
                StreamCategory.stats,
                StreamCategory.heap,
            ].forEach { stream in
                model.startStream(stream)
            }
        }
    }
}
