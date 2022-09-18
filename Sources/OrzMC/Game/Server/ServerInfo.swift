//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/1/13.
//

import Foundation

struct ServerInfo {
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
}
