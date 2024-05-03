//
//  File.swift
//  
//
//  Created by joker on 2024/1/21.
//

import JokerKits
import Utils

public extension Shell {
    
    static func allRunningServerPids() throws -> [String] {
        let pids = try Shell.pids(of: "nogui")
        return pids
    }
    static func stopAll(with pids: [String]? = nil) async throws {
        var allPids = Set<String>()
        pids?.forEach { allPids.insert($0) }
        try allRunningServerPids().forEach { allPids.insert($0) }
        for pid in allPids {
            if await Shell.exist(of: pid), await Shell.kill(with: pid, signalName: .interrupt) {
                Platform.console.success("正在停止服务端: ", newLine: false)
                Platform.console.info("PID = \(pid)")
            }
        }
    }
}

