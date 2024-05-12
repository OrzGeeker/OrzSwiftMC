//
//  File.swift
//
//
//  Created by joker on 5/12/24.
//

import Foundation
enum EndPoint {
    case account
    case servers(serverId: String? = nil)
    enum HttpMethod: String {
        case GET
        case POST
    }
    var httpMethod: HttpMethod {
        switch self {
        case .account, .servers:
            return .GET
        }
    }
    var urlComponent: String {
        switch self {
        case .account:
            return "account"
        case .servers(let serverId):
            if let serverId {
                return "servers/\(serverId)"
            } else {
                return "servers"
            }
        }
    }
}
