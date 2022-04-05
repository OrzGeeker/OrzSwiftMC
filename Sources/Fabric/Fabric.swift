//
//  Fabric.swift
//  
//
//  Created by joker on 2022/4/5.
//

import Foundation
import JokerKits

public struct Fabric {
    public static func launcherConfig(_ fileURL: URL) throws -> FabricModel {
        let data = try Data(contentsOf: fileURL)
        return try launcherConfig(data)
    }
    public static func launcherConfig(_ data: Data) throws -> FabricModel {
        let decoder = JSONDecoder()
        return try decoder.decode(FabricModel.self, from: data)
    }
}
