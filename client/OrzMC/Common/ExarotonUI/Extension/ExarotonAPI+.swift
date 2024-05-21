//
//  ExarotonAPI+.swift
//  OrzMC
//
//  Created by joker on 2024/5/20.
//

import Foundation
import ExarotonHTTP
import ExarotonWebSocket

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
typealias ServerStatus = ExarotonWebSocket.ServerStatus
extension ExarotonWebSocket.Server {
    var serverInfo: ExarotonServer {
        get throws {
            let data = try JSONEncoder().encode(self)
            let serverInfo = try JSONDecoder().decode(ExarotonServer.self, from: data)
            return serverInfo
        }
    }
}


