//
//  File.swift
//  
//
//  Created by joker on 5/12/24.
//

import Foundation
public struct AccountData: Codable {
    public let name: String
    public let email: String
    public let verified: Bool
    public let credits: Int
}
public struct ServerData: Codable, Identifiable {
    public let id: String
    public let name: String
    public let address: String
    public let motd: String
    public let status: Int
    public let host: String?
    public let port: Int?
    public let players: Players
    public let software: Software?
    public let shared: Bool
}
public struct Players: Codable {
    public let max: Int
    public let count: Int
    public let list: [String]
    
}
public struct Software: Codable, Identifiable {
    public let id: String
    public let name: String
    public let version: String
}
public struct ServerLogData: Codable {
    let content: String?
}
public struct ServerLogShareData: Codable, Identifiable {
    public let id: String
    public let url: String
    public let raw: String
}

public struct ServerRAMData: Codable {
    public let ram: Int     // 单位：GB
}
