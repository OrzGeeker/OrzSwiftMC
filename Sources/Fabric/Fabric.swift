//
//  Fabric.swift
//  
//
//  Created by joker on 2022/4/5.
//
//  [Fabric官方网站](https://fabricmc.net/)
//  [Mods下载网站](https://modrinth.com/mods)

import Foundation
import JokerKits

public struct Fabric {
    public enum InstallType {
        case client
        case server
    }
    public static func installFabric(_ installType: InstallType, installerFileURL: URL, installDir: String, version: String) async throws {
        await Shell.runCommand(with: [
            "java", "-jar" , "\(installerFileURL.path)",
            "\(installType == .client ? "client" : "server")",
            "-mcversion", "\(version)",
            "-dir", "\(installDir)"
        ])
    }
}

// MARK: 处理客户端Fabric
extension Fabric {
    /// 加载客户端Fabric Config文件并转换成Model
    /// - Parameter fileURL: 客户端json配置文件的路径
    /// - Returns: 转换后的数据模型
    public static func launcherConfig(_ fileURL: URL) throws -> FabricModel {
        let data = try Data(contentsOf: fileURL)
        return try launcherConfig(data)
    }
    
    /// 加载客户端Fabric Config文件并转换成Model
    /// - Parameter data: 客户端json配置文件的内存二进制内容
    /// - Returns: 转换后的数据模型
    public static func launcherConfig(_ data: Data) throws -> FabricModel {
        let decoder = JSONDecoder()
        return try decoder.decode(FabricModel.self, from: data)
    }
}

// MARK: 处理服务端Fabric
extension Fabric {
    
}
