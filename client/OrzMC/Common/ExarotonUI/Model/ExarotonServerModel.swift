//
//  ExarotonServerModel.swift
//  OrzMC
//
//  Created by joker on 2024/5/17.
//

import ExarotonHTTP
import ExarotonWebSocket
import OpenAPIRuntime
import OpenAPIURLSession
import SwiftUI

@Observable
final class ExarotonServerModel {

    var path = NavigationPath()

    static let accountTokenPersistentKey = "EXAROTON_TOKEN"

    @ObservationIgnored
    var token: String {
        get {
            return UserDefaults.standard.string(forKey: Self.accountTokenPersistentKey) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Self.accountTokenPersistentKey)
        }
    }


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
    var streamStopped: ExarotonWebSocket.StreamCategory?
    var consoleLine: String?
    var consoleLines = [String]()
    var tickChanged: ExarotonWebSocket.Tick?
    var statsChanged: ExarotonWebSocket.Stats?
    var heapChanged: ExarotonWebSocket.Heap?
}
