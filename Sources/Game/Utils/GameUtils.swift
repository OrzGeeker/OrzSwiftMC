//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation
import JokerKits
import Mojang

public struct GameUtils {
    
    public static func javaPath() throws -> String {
        let javaPath = try Shell.runCommand(with: ["which", "java"]).trimmingCharacters(in: .whitespacesAndNewlines)
        return javaPath
    }
    
    public static func releases() async -> [String] {
        return await Mojang.releases().compactMap { $0.id }
    }
    
    public static func releaseGameVersion(_ version: String) async -> [Version]? {
        return await Mojang.releases().filter { $0.id == version }
    }
}
