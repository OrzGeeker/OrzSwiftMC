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
        /// Start a server or Start a server with own credits
        case start(_: ServerStartData? = nil)
        /// Stop a server
        case stop
        /// Restart a server
        case restart
        /// Execute a server command
        case command(_: ServerCommandData? = nil)
        /// Get all or specified type of playlist
        enum PlayListOp {
            case add(_: PlayerList)
            case delete(_: PlayerList)
        }
        case playlist(_:String? = nil, op: PlayListOp? = nil)
    }
    enum HttpMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
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
                return postIfExist(ram)
            case .motd(let motd):
                return postIfExist(motd)
            case .start(let ownCredits):
                return postIfExist(ownCredits)
            case .command:
                return .POST
            case .playlist(_, let op):
                guard let op
                else {
                    return .GET
                }
                switch op {
                case .add:
                    return .PUT
                case .delete:
                    return .DELETE
                }
            default:
                return .GET
            }
        }

        func postIfExist(_ postBody: Codable?) -> HttpMethod { postBody != nil ? .POST : .GET }
    }
    var path: String {
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
            case .start:
                component += "/start"
            case .stop:
                component += "/stop"
            case .restart:
                component += "/restart"
            case .command:
                component += "/command"
            case .playlist(let type, _):
                component += "/playerlists"
                if let type {
                    component += "/\(type)"
                }
            }
            return component
        }
    }
    var httpBodyModel: Encodable? {
        switch self {
        case .servers(_, let op):
            switch op {
            case .ram(let ram):
                return ram
            case .motd(let motd):
                return motd
            case .start(let ownCredits):
                return ownCredits
            case .command(let command):
                return command
            case .playlist(_, let op):
                guard let op
                else {
                    return nil
                }
                switch op {
                case .add(let addPlayers):
                    return addPlayers
                case .delete(let delPlayers):
                    return delPlayers
                }
            default:
                return nil
            }
        default:
            return nil
        }
    }
}
