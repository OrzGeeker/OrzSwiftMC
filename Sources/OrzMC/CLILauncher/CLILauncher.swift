//
//  CLILauncher.swift
//  
//
//  Created by joker on 2022/1/3.
//

/// Minecraft 客户端启动器
///
/// [写启动器参考文章](https://wiki.vg/Game_files)
///
/// [启动器Wiki](https://minecraft.fandom.com/zh/wiki/教程/编写启动器)

import Game
import JokerKits

public struct CLILauncher: Client {
    
    /// 客户端启动器启动参数相关
    public var clientInfo: ClientInfo
        
    /// 客户端启动
    mutating public func start() async throws {
        
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
    
    /// 授权验证
    mutating func authenticate() async throws {
        guard try await auth() else {
            return
        }
        Platform.console.output("验证账号密码为正版用户", style: .success)
    }
    
    /// 启动客户端
    mutating func launch() async throws {
        guard let args = try await parseBootArgs() else {
            return
        }
        Platform.console.output("客户端正在启动，请稍等......", style: .success)
        // 客户端启动后，可以从UI界面关闭，所以可以异步启动
        let gameDir = GameDir.client(version: clientInfo.version.id).dirPath
        try Shell.run(path: try GameUtils.javaPath(), args: args, workDirectory: gameDir, terminationHandler: { process in
            guard process.terminationStatus == 0 else {
                Platform.console.output("客户端异常退出", style: .error)
                return
            }
            Platform.console.output("客户端正常", style: .success)
        })
    }
    
    /// 下载启动器启动需要的文件
    func download() async throws {
        Platform.console.pushEphemeral()
        let downloadItems = try await generateDownloadItemInfos()
        let progressBar = Platform.console.progressBar(title: "正在下载客户端文件")
        try await Downloader.download(downloadItems, progressBar: progressBar)
        Platform.console.popEphemeral()
        Platform.console.output("下载客户端文件完成", style: .success)
    }
    
    /// 下载Fabric客户端相关文件
    mutating func downloadFabric() async throws {
        guard let downloadItemInfos = try fabricDownloadItems() else {
            return
        }
        let progressBar = Platform.console.progressBar(title: "开始下载Fabric库文件")
        try await Downloader.download(downloadItemInfos, progressBar: progressBar)
        Platform.console.output("下载Fabric库文件完成".consoleText(.success))
    }
    
    /// 选择客户端启动方式
    mutating func chooseProfile() throws  {
        let menuItems = try launcherProfileItems()
        var chooseItem = menuItems.first
        if menuItems.count > 1 {
            chooseItem = Platform.console.choose("选择启动方式：".consoleText(.success), from: menuItems)
        }
        guard let chooseItem = chooseItem else {
            return
        }
        Platform.console.output("启动：".consoleText(.success), newLine: false)
        Platform.console.output(chooseItem.consoleText(.info))
        try selectedProfile(chooseItem)
    }
}
