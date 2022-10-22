//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation

public extension Mojang {
    
    static func releases() async -> [Version] {
        guard let releases = try? await Mojang.manifest?.versions.filter({ $0.type == "release" })
        else {
            return []
        }
        return releases
    }
}
