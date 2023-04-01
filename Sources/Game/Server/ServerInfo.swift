//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/1/13.
//

import Foundation

public struct ServerInfo {
    let version: String
    let gui: Bool
    let debug: Bool
    let forceUpgrade: Bool
    
    // JVM启动内存占用参数
    var minMem: String
    var maxMem: String
    
    // 服务端参数
    var onlineMode: Bool // 是否以online模式运行服务端
    var showJarHelpInfo: Bool // 显示服务端Jar包帮助信息
    
    // Jar包对应的参数
    var jarOptions: String?
    
    public init(version: String, gui: Bool, debug: Bool, forceUpgrade: Bool, minMem: String, maxMem: String, onlineMode: Bool, showJarHelpInfo: Bool, jarOptions: String?) {
        self.version = version
        self.gui = gui
        self.debug = debug
        self.forceUpgrade = forceUpgrade
        self.minMem = minMem
        self.maxMem = maxMem
        self.onlineMode = onlineMode
        self.showJarHelpInfo = showJarHelpInfo
        self.jarOptions = jarOptions
    }
}
