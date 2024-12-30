//
//  File.swift
//
//
//  Created by joker on 2024/1/21.
//

import JokerKits

public extension Shell {
    
    static func allRunningServerPids() throws -> [String] {
        let pids = try Shell.pids(of: "nogui")
        return pids
    }
    
    @discardableResult
    static func stopAll(with pids: [String]? = nil) async throws -> [String] {
        var allPids = Set<String>()
        pids?.forEach { allPids.insert($0) }
        try allRunningServerPids().forEach { allPids.insert($0) }
        
        var stoppedPids = [String]()
        for pid in allPids {
            if await Shell.exist(of: pid), await Shell.kill(with: pid, signalName: .interrupt) {
                stoppedPids.append(pid)
            }
        }
        return stoppedPids
    }
}
