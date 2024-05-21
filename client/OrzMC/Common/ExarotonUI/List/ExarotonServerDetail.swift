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

    @State private var consoleLog: String = ""

    @State private var consoleCommand: String = ""

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

                if let stats = model.statsChanged {
                    HStack {
                        Gauge(value: stats.cpu.percent, in: 0...Double(100 * stats.cpu.limit)) {
                            Text("CPU x \(stats.cpu.limit)")
                        } currentValueLabel: {
                            Text("\(String(format: "%.2f", stats.cpu.percent))%")
                        }
                        Gauge(value: stats.memory.percent, in: 0...100) {
                            Text("Memory(\(String(format: "%.2f", stats.memory.usage * 100 / stats.memory.percent / Double(1024 * 1024 * 1024))) GB)")
                        } currentValueLabel: {
                            Text("\(String(format: "%.2f", stats.memory.percent))%")
                        }
                    }
                }
                if let tick = model.tickChanged {
                    Text("Tick: \(tick.averageTickTime)")
                }
                if let heap = model.heapChanged {
                    Text("Heap: \(String(format: "%.2f", Double(heap.usage) / Double(1024 * 1024 * 1024))) GB")
                }

                Section("Console") {

                    ScrollView(.vertical, showsIndicators: true) {
                        Text(consoleLog)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 8))
                    }
                    .frame(maxHeight: 100)
                    .listRowBackground(Color.black)

                    Button {
                        consoleLog = ""
                    } label: {
                        Text("Clear Console")
                    }

                    Button("Start Console") {
                        model.startStream(.console, data: ["tail": 10])
                    }

                    Button("Stop Console") {
                        model.stopStream(.console)
                    }

                    Button("Send Console Command") {
                        model.sendConsoleCmd("say Hello")
                    }
                }

                if serverStatus != .OFFLINE {
                    Section("Streams - WebSocket") {
                        ForEach([
                            StreamCategory.tick,
                            StreamCategory.stats,
                            StreamCategory.heap
                        ], id: \.self) { streamCategory in
                            VStack {
                                HStack {
                                    Button("start \(streamCategory.rawValue)") {
                                        model.startStream(streamCategory)
                                    }
                                    Button("stop \(streamCategory.rawValue)") {
                                        model.stopStream(streamCategory)
                                    }
                                }
                                .buttonStyle(BorderedProminentButtonStyle())
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
        .onChange(of: model.consoleLine) { oldValue, newValue in
            guard let consoleLine = newValue
            else {
                return
            }
            consoleLog.append(consoleLine)
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
