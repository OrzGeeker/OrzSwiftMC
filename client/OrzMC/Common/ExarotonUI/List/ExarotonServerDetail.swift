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

    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    @State private var showConsoleCommandInput = false
    @State private var consoleCommand: String = ""

    var body: some View {

        @Bindable var model = model

        Form {

            Section("General") {
                ExarotonServerView(server: server, showStatus: false, showMotd: true)
            }

            if let playlist = server.players?.list, !playlist.isEmpty {
                Section("Playlist") {
                    ExarotonServerPlayList(playlist: playlist)
                }
            }

            if let serverStatus = server.serverStatus {

                if model.isConnected {
                    Section("Metrics") {
                        VStack(alignment: .center, spacing: 10) {
                            if let stats = model.statsChanged {
                                HStack(alignment: .center, spacing: 20) {
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
                                Text("Tick: \(String(format: "%.2f", tick.averageTickTime))")
                            }
                            if let heap = model.heapChanged {
                                Text("Heap: \(String(format: "%.2f", Double(heap.usage) / Double(1024 * 1024 * 1024))) GB")
                            }
                        }
                    }
                }

                Section("Actions") {

                    if serverRAM > 0 {
                        Stepper("RAM: \(String(format: "%d", serverRAM)) GB",
                                value: $serverRAM,
                                in: 2...16,
                                step: 1
                        )
                        .disabled(loading || serverStatus != .OFFLINE)
                    }

                    Button("Start Server", systemImage: "restart.circle") {
                        Task {
                            await model.startServer(serverId: server.id!)
                        }
                    }.disabled(serverStatus != .OFFLINE)

                    Button("Stop Server", systemImage: "stop.fill") {
                        Task {
                            await model.stopServer(serverId: server.id!)
                        }
                    }
                    .disabled(serverStatus != .ONLINE)

                    Button("Restart Server", systemImage: "restart.circle.fill") {
                        Task {
                            await model.restartServer(serverId: server.id!)
                        }
                    }
                    .disabled(serverStatus != .ONLINE)
                }

                if model.isConnected {

                    Section("Console") {

                        ScrollView(.vertical, showsIndicators: true) {
                            Text(consoleLog)
                                .foregroundStyle(Color.white)
                                .font(.system(size: 8))
                        }
                        .frame(height: 100)
                        .listRowBackground(Color.black)

                        Button {
                            consoleLog = ""
                        } label: {
                            Text("Clear Console")
                        }

                        Button("Send Console Command") {
                            showConsoleCommandInput = true
                        }
                        .keyboardShortcut(.init("c"), modifiers: .command)
                    }
                }
            }
        }
        .formStyle(GroupedFormStyle())
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

                if let serverStatus = server.serverStatus {
                    ExarotonServerStatusView(status: serverStatus)
                        .frame(width: 25, height: 25)
                }
            }
        }
        .overlay {
            ProgressView()
                .controlSize(.extraLarge)
                .progressViewStyle(.circular)
                .opacity(loading ? 1 : 0)
        }
        .sheet(isPresented: $showConsoleCommandInput) {
            if !consoleCommand.isEmpty {
                let validCommand = consoleCommand.trimmingCharacters(in: .whitespacesAndNewlines)
                model.sendConsoleCmd(.init(validCommand))
                consoleCommand = ""
            }
        } content: {
            VStack(alignment: .leading, spacing: 10) {
                Text("Input Command")
                    .font(.headline)
                    .frame(minWidth: 300, alignment: .leading)

                TextEditor(text: $consoleCommand)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                    .foregroundStyle(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
#if os(macOS)
                    .frame(maxWidth: 400, minHeight: 100)
#endif
#if os(iOS)
                    .keyboardType(.alphabet)
#endif
            }
            .padding()
            .onSubmit {
                showConsoleCommandInput = false
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(300)])
            .presentationCornerRadius(10)
            .presentationCompactAdaptation(horizontal: .none, vertical: .sheet)
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
        .onReceive(timer) { _ in
            guard let serverStatus = server.serverStatus, serverStatus == .ONLINE, model.isConnected == false
            else {
                return
            }
            startStreams()
        }
    }
}

extension ExarotonServerDetail {

    static let actionStreams = StreamCategory.allCases.filter { $0 != .status }

    func startStreams() {
        Self.actionStreams.forEach { model.startStream($0) }
    }

    func stopStreams() {
        Self.actionStreams.forEach { model.stopStream($0) }
    }
}
