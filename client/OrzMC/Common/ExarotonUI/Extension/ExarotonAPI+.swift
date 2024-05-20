//
//  ExarotonAPI+.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import Foundation
import ExarotonHTTP
import ExarotonWebSocket

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
typealias ExarotonServer = ExarotonHTTP.Components.Schemas.Server
extension ExarotonServer: Identifiable {}
extension ExarotonServer {

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

    var hasAddress: Bool {
        return staticAddress?.isEmpty == false || dynamicAddress?.isEmpty == false
    }
}

typealias ExarotonCreditPool = ExarotonHTTP.Components.Schemas.CreditPool
extension ExarotonCreditPool: Identifiable {}
typealias ExarotonCreditMember = ExarotonHTTP.Components.Schemas.CreditPoolMember
extension ExarotonCreditMember: Identifiable {
    public var id: String { account ?? name ?? "" }
}

// WebSocket
extension ExarotonWebSocket.Server {
    var serverInfo: ExarotonServer {
        get throws {
            let data = try JSONEncoder().encode(self)
            let serverInfo = try JSONDecoder().decode(ExarotonServer.self, from: data)
            return serverInfo
        }
    }
}

extension ExarotonWebSocketAPI {
    
    func connect() {
        client.connect()
    }
    
    func disconnect() {
        client.disconnect()
    }

    func send<T: Codable>(message: ExarotonMessage<T>) {
        do {
            let data = try message.toData
            client.write(stringData: data, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
}
