//
//  Launcher.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Mojang
import Fabric

/// Minecraft 客户端启动器
///
/// [写启动器参考文章](https://wiki.vg/Game_files)
///
/// [启动器Wiki](https://minecraft.fandom.com/zh/wiki/教程/编写启动器)
class Launcher: Client {
    
    /// 客户端启动器启动参数相关
    var clientInfo: ClientInfo
    
    init(clientInfo: ClientInfo) {
        self.clientInfo = clientInfo
    }
    
    /// 客户端启动
    func start() async throws {
        
        // 选择启动的方式
        try self.chooseProfile()
        
        // 正版验证
        try await self.authenticate()
        
        // 下载启动器启动所需要的文件、资源及依赖
        try await self.download()
        
        // 下载Fabric相关的库
        try await self.downloadFabric()
        
        // 分析参数并启动客户端
        try await self.launch()
    }
}


struct ClientInfo {
    var version: Version
    var username: String
    var debug: Bool
    var authenticate: Bool
    var launcherProfile: LauncherProfile?
    
    // 正版授权
    var accountName: String?
    var accountPassword: String?
    var accessToken: String?
    var clientToken: String?
    
    // JVM启动内存占用参数
    var minMem: String
    var maxMem: String
    
    // Fabric
    var fabricModel: FabricModel?
}
