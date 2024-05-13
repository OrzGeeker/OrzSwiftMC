//
//  File.swift
//
//
//  Created by joker on 5/12/24.
//

import Foundation
enum EndPoint {
    /// Get account Info
    case account

    /// List servers or Get a server with serverId
    case servers(serverId: String? = nil, op: ServerOp? = nil)


    enum ServerOp {
        /// Get a server log of serverId
        case logs
        /// Upload a server log to mclo.gs
        case logsShare
        /// Get or Set server RAM
        case ram(_: ServerRAMData? = nil)
        /// Get or Set server MOTD
        case motd(_: ServerMOTDData? = nil)
    }
    enum HttpMethod: String {
        case GET
        case POST
    }

    var httpMethod: HttpMethod {
        switch self {
        case .account:
            return .GET
        case .servers(_, let op):
            guard let op
            else {
                return .GET
            }
            switch op {
            case .logs, .logsShare:
                return .GET
            case .ram(let ram):
                guard ram != nil
                else {
                    return .GET
                }
                return .POST
            case .motd(let motd):
                guard motd != nil
                else {
                    return .GET
                }
                return .POST
            }
        }
    }
    var urlComponent: String {
        switch self {
        case .account:
            return "account"
        case .servers(let serverId, let op):
            var component = "servers"
            if let serverId {
                component += "/\(serverId)"
            }
            guard let op
            else {
                return component
            }
            switch op {
            case .logs:
                component += "/logs"
            case .logsShare:
                component += "/logs/share"
            case .ram:
                component += "/options/ram"
            case .motd:
                component += "/options/motd"
            }
            return component
        }
    }
    var postBodyModel: Encodable? {
        switch self {
        case .servers(_, let op):
            switch op {
            case .ram(let ram):
                return ram
            case .motd(let motd):
                return motd
            default:
                return nil
            }
        default:
            return nil
        }
    }
}
