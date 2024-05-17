//
//  ExarotonServerModel.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import ExarotonHTTP
import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI

import Foundation
import ExarotonWebSocket
import Starscream

let mainColor = Color.init(red: 0.1, green: 0.73, blue: 0.1)
let dangerColor = Color.init(red: 0.98, green: 0.11, blue: 0.11)

enum ServerStatus: Int, CaseIterable {
    case OFFLINE = 0
    case ONLINE = 1
    case STARTING = 2
    case STOPPING = 3
    case RESTARTING = 4
    case SAVING = 5
    case LOADING = 6
    case CRASHED = 7
    case PENDING = 8
    case PREPARING = 10
}
typealias ExarotonServerInfo = ExarotonHTTP.Components.Schemas.Server
extension ExarotonServerInfo {
    
    var detail: String? {
        var ret = ""
        if let software {
            ret += "\(software.name ?? "-") \(software.version ?? "-")"
        }
        if let players {
            ret += " - (\(players.count ?? 0)/\(players.max ?? 0))"
        }
        return ret
    }
    
    var serverStatus: ServerStatus? {
        guard let status
        else {
            return nil
        }
        return ServerStatus(rawValue: status.rawValue)
    }
    
    var staticAddress: String? {
        guard let address, let port
        else {
            return nil
        }
        return "\(address):\(String(port))"
    }
    
    var dynamicAddress: String? {
        guard let host, let port
        else {
            return nil
        }
        return "\(host):\(String(port))"
    }
}

@Observable
final class ExarotonServerModel {
    
    @ObservationIgnored
    let token: String = ProcessInfo.processInfo.environment["TOKEN"] ?? ""
    
    // HTTP Client
    @ObservationIgnored
    private lazy var httpClient: Client = {
        Client(serverURL: try! Servers.server1(),
               transport: URLSessionTransport(),
               middlewares: [AuthenticationMiddleware(token: token)]
        )
    }()
    
    var isHttpLoading = false
    
    var servers = [ExarotonServerInfo]()
    
    func fetchServers() async {
        isHttpLoading = true
        do {
            let response = try await httpClient.getServers()
            switch response {
            case .ok(let ok):
                if let data = try ok.body.json.data {
                    servers = data
                }
            default:
                break
            }
        } catch let error {
            print(error.localizedDescription)
        }
        isHttpLoading = false
    }
    
    func startServer(serverId: String) async -> Bool {
        do {
            let reponse = try await httpClient.getStartServer(path: .init(serverId: serverId))
            switch reponse {
            case .ok(let ok):
                let json = try ok.body.json
                return json.success ?? false
            default:
                return false
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func stopServer(serverId: String) async -> Bool {
        do {
            let reponse = try await httpClient.stopServer(path: .init(serverId: serverId))
            switch reponse {
            case .ok(let ok):
                let json = try ok.body.json
                return json.success ?? false
            default:
                return false
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    func restartServer(serverId: String) async -> Bool {
        do {
            let reponse = try await httpClient.restartServer(path: .init(serverId: serverId))
            switch reponse {
            case .ok(let ok):
                let json = try ok.body.json
                return json.success ?? false
            default:
                return false
            }
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    // MARK: WebSocket Client
    
    @ObservationIgnored
    private var websocket: ExarotonWebSocketAPI?
    
    var readyServerID: String?
    var isConnected: Bool = false
    var disconnectedReason: String?
    var statusChangedServer: ExarotonWebSocket.Server?
    var streamStarted: ExarotonWebSocket.StreamCategory?
    var consoleLine: String?
    var tickChanged: ExarotonWebSocket.Tick?
    var statsChanged: ExarotonWebSocket.Stats?
    var heapChanged: ExarotonWebSocket.Heap?
    
    func startConnect(for serverId: String) {
        if websocket == nil {
            websocket = ExarotonWebSocketAPI(token: token, serverId: serverId, delegate: self)
        }
        websocket?.client.connect()
    }
    func stopConnect() {
        websocket?.client.disconnect()
    }
}

// MARK: WebSocket
extension ExarotonWebSocket.Server {
    var serverInfo: ExarotonServerInfo {
        get throws {
            let data = try JSONEncoder().encode(self)
            let serverInfo = try JSONDecoder().decode(ExarotonServerInfo.self, from: data)
            return serverInfo
        }
    }
}
extension ExarotonServerModel: ExarotonServerEventHandlerProtocol {
    
    func onReady(serverID: String?) {
        readyServerID = serverID
    }
    
    func onConnected() {
        isConnected = true
        disconnectedReason = nil
    }
    
    func onDisconnected(reason: String?) {
        isConnected = false
        disconnectedReason = reason
    }
    
    func onKeepAlive() {
        // Ignore
    }
    
    func onStatusChanged(_ info: ExarotonWebSocket.Server?) {
        statusChangedServer = info
    }
    
    func onStreamStarted(_ stream: ExarotonWebSocket.StreamCategory?) {
        streamStarted = stream
    }
    
    func onConsoleLine(_ line: String?) {
        consoleLine = line
    }
    
    func onTick(_ tick: ExarotonWebSocket.Tick?) {
        tickChanged = tick
    }
    
    func onStats(_ stats: ExarotonWebSocket.Stats?) {
        statsChanged = stats
    }
    
    func onHeap(_ heap: ExarotonWebSocket.Heap?) {
        heapChanged = heap
    }
    
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        // Do Nothing
    }
    
}

extension String {
    func copyToPasteboard() {
        UIPasteboard.general.string = self
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }
}
