//
//  ExarotonServerModel.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import Foundation
import ExarotonHTTP
import ExarotonWebSocket
import OpenAPIRuntime
import OpenAPIURLSession

@Observable
final class ExarotonServerModel {

    @ObservationIgnored
    let token: String = ProcessInfo.processInfo.environment["TOKEN"] ?? ""

    // HTTP Client
    @ObservationIgnored
    lazy var httpClient: Client = {
        Client(serverURL: try! Servers.server1(),
               transport: URLSessionTransport(),
               middlewares: [AuthenticationMiddleware(token: token)]
        )
    }()
    
    var servers = [ExarotonServer]()
    var creditPools = [ExarotonCreditPool]()

    // WebSocket Client
    @ObservationIgnored
    var websocket: ExarotonWebSocketAPI?

    var readyServerID: String?
    var isConnected: Bool = false
    var disconnectedReason: String?
    var statusChangedServer: ExarotonWebSocket.Server?
    var streamStarted: ExarotonWebSocket.StreamCategory?
    var consoleLine: String?
    var tickChanged: ExarotonWebSocket.Tick?
    var statsChanged: ExarotonWebSocket.Stats?
    var heapChanged: ExarotonWebSocket.Heap?
}
