//
//  File.swift
//  
//
//  Created by joker on 2022/1/3.
//

public protocol Client: Sendable {
    var clientInfo: ClientInfo { get set}
    mutating func start() async throws
    func launcherProfileItems() throws -> [String]
}
