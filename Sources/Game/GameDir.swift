//
//  File.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Foundation
import JokerKits
import ConsoleKit

public enum GameType: String, Sendable {
    case vanilla
    case paper
}

public enum GameError: Error {
    case noGameVersions
}

public enum GameDir {
    
    public static let defaultClientType = GameType.vanilla.rawValue
    public static let defaultServerType = GameType.vanilla.rawValue

    case home
    case minecraft
    case manifest
    case gameVersion(version: String)
    case client(version: String, type: String = defaultClientType)
    case assets(version: String, type: String = defaultClientType)
    case assetsIdx(version: String, type: String = defaultClientType)
    case assetsObj(version: String, type: String = defaultClientType, path: String)
    case libraries(version: String, type: String = defaultClientType)
    case libraryObj(version: String, type: String = defaultClientType, path: String)
    case clientVersion(version: String, type: String = defaultClientType)
    case clientVersionProfile(version: String, profile: String, type: String = defaultClientType)
    case clientVersionProfileLibraries(version: String, profile: String, type: String = defaultClientType)
    case clientVersionNative(version: String, type: String = defaultClientType)
    case clientLogConfig(version: String, type: String = defaultClientType)
    case server(version: String, type: String = defaultServerType)
    case serverPlugin(version: String, type: String = defaultServerType)
    
    private var pathComponents: [String] {
        switch self {
        case .home:
            return [NSHomeDirectory()]
        case .minecraft:
            return GameDir.home.pathComponents + ["minecraft"]
        case .manifest:
            return GameDir.minecraft.pathComponents + ["manifest"]
        case .gameVersion(let version):
            return GameDir.manifest.pathComponents + [version]
        case .client(let version, let type):
            return GameDir.gameVersion(version: version).pathComponents + ["client", type]
        case .assets(let version, let type):
            return GameDir.client(version: version, type: type).pathComponents + ["assets"]
        case .assetsIdx(let version, let type):
            return GameDir.assets(version: version, type: type).pathComponents + ["indexes"]
        case .assetsObj(let version, let type, let path):
            return GameDir.assets(version: version, type: type).pathComponents + ["objects", path]
        case .clientLogConfig(let version, let type):
            return GameDir.assets(version: version, type: type).pathComponents + ["log_configs"]
        case .libraries(let version, let type):
            return GameDir.client(version: version, type: type).pathComponents + ["libraries"]
        case .libraryObj(let version, let type, let path):
            return GameDir.libraries(version: version, type: type).pathComponents + [path]
        case .clientVersion(let version, let type):
            return GameDir.client(version: version, type: type).pathComponents + ["versions", version]
        case .clientVersionProfile(let version, let profile, let type):
            return GameDir.client(version: version, type: type).pathComponents + ["versions", profile]
        case .clientVersionProfileLibraries(let version, let profile, let type):
            return GameDir.clientVersionProfile(version: version, profile: profile, type: type).pathComponents + ["libraries"]
        case .clientVersionNative(let version, let type):
            let nativesPlatform = "\(version)-natives"
            return GameDir.clientVersion(version: version, type: type).pathComponents + [nativesPlatform]
        case .server(let version, let type):
            return GameDir.gameVersion(version: version).pathComponents + ["server", type]
        case .serverPlugin(let version, let type):
            return GameDir.server(version: version, type: type).pathComponents + ["plugins"]
        }
    }
    
    public var dirPath: String {
        return NSString.path(withComponents: self.pathComponents)
    }
    
    public func filePath(_ filename: String) -> String {
        return NSString.path(withComponents: self.pathComponents + [filename])
    }
}
