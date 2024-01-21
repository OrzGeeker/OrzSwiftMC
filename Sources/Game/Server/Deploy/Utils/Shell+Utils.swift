//
//  File.swift
//  
//
//  Created by joker on 2024/1/21.
//

import JokerKits

public extension Shell {
    
    static func stopAll(with pids: [String]? = nil) async throws {
        var allPids = Set<String>()
        pids?.forEach { allPids.insert($0) }
        try Shell.pids(of: "nogui").forEach { allPids.insert($0) }
        for pid in allPids {
            if await Shell.exist(of: pid), await Shell.kill(with: pid) {
                Platform.console.success("服务端停止: ", newLine: false)
                Platform.console.info("PID = \(pid)")
            }
        }
    }
}

