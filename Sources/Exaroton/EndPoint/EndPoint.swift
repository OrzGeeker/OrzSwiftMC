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
    case servers(serverId: String? = nil, op: ServerOp? = nil)


    enum CreditPoolOp {
        case members
        case servers
    }
    case creditPool(poolId: String? = nil, op: CreditPoolOp? = nil)
}
