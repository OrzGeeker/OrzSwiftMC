//
//  PluginInfo.swift
//  
//
//  Created by wangzhizhou on 2022/3/28.
//

import Foundation
import JokerKits

public struct PluginInfo: Codable, JsonRepresentable {
    public let name: String
    public let desc: String
    public let url: String
    public var type: PluginType
    public var downloadType: PluginDownloadType
    public var status: PluginStatus = .available
    public let site: String?
    public let docs: String?
    public let repo: String?
    public var enable: Bool = true
    
    public enum PluginType: String, Codable {
        case bukkit
        case spigot
        case paper
    }
    
    public enum PluginDownloadType: String, Codable {
        case automatic
        case manual
        case needAuth
    }
    
    public enum PluginStatus: String, Codable {
        case available
        case deprecated
        case unavailable
    }
}
