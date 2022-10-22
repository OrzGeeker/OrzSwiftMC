//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation
import JokerKits

struct GameUtils {
    static func javaPath() throws -> String {
        let javaPath = try Shell.runCommand(with: ["which", "java"]).trimmingCharacters(in: .whitespacesAndNewlines)
        return javaPath
    }
}
