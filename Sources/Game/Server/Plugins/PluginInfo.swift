//
//  PluginInfo.swift
//  
//
//  Created by wangzhizhou on 2022/3/28.
//

import Foundation
import JokerKits

public struct PluginInfo: Codable, JsonRepresentable {
    let name: String
    let desc: String
    let url: String
    var type: PluginType
    var downloadType: PluginDownloadType
    let site: String?
    let docs: String?
    let repo: String?
    var enable: Bool = true
    
    enum PluginType: String, Codable {
        case bukkit
        case spigot
        case paper
    }
    
    enum PluginDownloadType: String, Codable {
        case automatic
        case manual
    }
}
