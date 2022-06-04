//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/1/12.
//

import Mojang
import JokerKits
import Foundation

enum VanillaServerError: Error {
    case getServerInfoFailed
    case launchFailed
}

/// Vanilla 服务器
///
/// 启动命令示例:
/// ```bash
/// java -Xmx1024M -Xms1024M -jar minecraft_server.1.18.1.jar nogui
/// ```
///
/// 1. [官方部署服务器文档](https://www.minecraft.net/en-us/download/server)
/// 2. [部署服务器百科文档](https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server)
///
/// 官方服务端文件下载速度太慢, 容易超时
struct VanillaServer: Server {
    
    let serverInfo: ServerInfo
    
    func start() async throws {
        
        guard let serverVersion = try await Mojang.manifest?.versions.filter({ $0.id == serverInfo.version }).first?.gameInfo?.downloads.server
        else {
            throw VanillaServerError.getServerInfoFailed
        }
        
        let serverJarFileName = serverVersion.url.lastPathComponent
        let serverJarFileDirPath = GameDir.server(version: serverInfo.version, type: GameType.vanilla.rawValue)
        let serverJarFilePath = serverJarFileDirPath.filePath(serverJarFileName)
        let serverJarFileURL = URL(fileURLWithPath: serverJarFilePath)
        let serverJarFileItem = DownloadItemInfo(sourceURL: serverVersion.url, dstFileURL: serverJarFileURL, hash: serverVersion.sha1, hashType: .sha1)
        
        let loading = Platform.console.loadingBar(title: "正在下载服务端文件")
        loading.start()
        try await Downloader.download(serverJarFileItem)
        loading.succeed()

        try await launchServer(serverJarFilePath, workDirectory: serverJarFileDirPath)
    }
}
