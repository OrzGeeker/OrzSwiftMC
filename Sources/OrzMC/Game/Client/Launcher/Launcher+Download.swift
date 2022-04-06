//
//  File.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Mojang
import JokerKits
import Foundation
import ConsoleKit


extension Launcher {
    
    /// 下载启动器启动需要的文件
    public func download() async throws {
        try await downloadClient()
        try await downloadAssets()
        try await downloadLibraries()
        try await downloadLogConfigFile()
    }
    
    /// 下载游戏客户端jar文件
    private func downloadClient() async throws {
        guard let client = try await self.clientInfo.version.gameInfo?.downloads.client
        else {
            return
        }
        // 下载版本信息JSON文件
        if let url = clientInfo.version.url, let data = try await url.getData {
            let dir = GameDir.clientVersion(version: clientInfo.version.id)
            try dir.dirPath.makeDirIfNeed()
            let filePath = dir.filePath(url.lastPathComponent)
            let fileURL = URL(fileURLWithPath: filePath)
            try data.write(to: fileURL)
        }
        // 下载版本Jar文件
        Platform.console.pushEphemeral()
        let filename = [clientInfo.version.id, client.url.pathExtension].joined(separator: ".")
        let progressHint = "下载客户端文件: \(filename)"
        Platform.console.output(progressHint, style: .info)
        try await GameUtils.download(
            client.url,
            progressHint: progressHint,
            targetDir: GameDir.clientVersion(version: clientInfo.version.id),
            hash: client.sha1,
            filename: filename
        )
        Platform.console.popEphemeral()
        Platform.console.output("下载客户端文件完成", style: .success)
    }
    
    /// 下载游戏客户端资源文件
    private func downloadAssets() async throws {
        guard let assetIndex = try await self.clientInfo.version.gameInfo?.assetIndex, let objects = try await assetIndex.assetInfo?.objects
        else {
            return
        }
        // 下载资源索引文件json
        Platform.console.pushEphemeral()
        let indexFileName = assetIndex.url.lastPathComponent
        let progressHint = "下载资源索引文件: \(indexFileName)"
        Platform.console.output(progressHint, style: .info)
        try await GameUtils.download(
            assetIndex.url,
            progressHint: progressHint,
            targetDir: .assetsIdx(version: clientInfo.version.id),
            hash: assetIndex.sha1,
            filename: indexFileName
        )
        Platform.console.popEphemeral()
        Platform.console.output("下载资源索引文件完成", style: .success)
        // 下载资源对象文件
        Platform.console.pushEphemeral()
        Platform.console.output("下载资源文件", style: .info)
        var count = 0
        let total = objects.count
        for filename in objects.keys {
            count += 1
            guard let info = objects[filename]
            else {
                continue
            }
            Platform.console.pushEphemeral()
            let assetObjURL = Mojang.assetObjURL(info.filePath())
            try await GameUtils.download(
                assetObjURL,
                progressHint: "(\(count)/\(total)) \(filename)",
                targetDir: GameDir.assetsObj(version: clientInfo.version.id, path: info.dirPath()),
                hash: info.hash
            )
            Platform.console.popEphemeral()
        }
        Platform.console.popEphemeral()
        Platform.console.output("下载资源文件完成", style: .success)
    }
    
    /// 下载游戏客户端jar库文件
    private func downloadLibraries() async throws {
        guard let libraries = try await self.clientInfo.version.gameInfo?.libraries
        else{
            return
        }
        Platform.console.pushEphemeral()
        Platform.console.output("下载库文件", style: .info)
        var count = 0
        let total = libraries.count
        for lib in libraries {
            count += 1
            // 获取需要下载的库
            var artifact = lib.downloads.artifact
            let dirPath = NSString(string: artifact.path).deletingLastPathComponent
            var targetDir = GameDir.libraryObj(version: clientInfo.version.id, path: dirPath)
            var libName = lib.name
            
            let currentOSName = Platform.os().platformName()
            if let natives = lib.natives, let nativeClassifier = natives[currentOSName], let nativeArtifact = lib.downloads.classifiers?[nativeClassifier] {
                artifact = nativeArtifact
                targetDir = GameDir.clientVersionNative(version: clientInfo.version.id)
                libName = [lib.name, nativeClassifier].joined(separator: ":")
            }
            
            // 判断当前平台是否需要下载
            var allowDownload = true
            if let rules = lib.rules {
                var allowOSSet = Set<String>()
                rules.forEach { rule in
                    if rule.action == "allow" {
                        if let osname = rule.os?.name {
                            allowOSSet.insert(osname)
                        }
                        else {
                            allowOSSet.insert(currentOSName)
                        }
                    }
                    else if rule.action == "disallow", let osName = rule.os?.name {
                        allowOSSet.remove(osName)
                    }
                }
                allowDownload = allowOSSet.contains(currentOSName)
            }
            
            if lib.rules == nil, let natives = lib.natives, !natives.keys.contains(currentOSName) {
                allowDownload = false
            }
            
            guard allowDownload else {
                if clientInfo.debug {
                    let info = "下载库文件(\(count)/\(total))：\(lib.name)".consoleText() + " [Not Need]".consoleText(.info)
                    Platform.console.output(info)
                }
                continue
            }
            Platform.console.pushEphemeral()
            try await GameUtils.download(
                artifact.url,
                progressHint: "(\(count)/\(total)) \(libName)",
                targetDir: targetDir,
                hash: artifact.sha1
            )
            Platform.console.popEphemeral()
        }
        Platform.console.popEphemeral()
        Platform.console.output("下载库文件完成", style: .success)
    }
    
    private func downloadLogConfigFile() async throws {
        guard let clientFile = try await self.clientInfo.version.gameInfo?.logging.client.file
        else {
            return
        }
        Platform.console.pushEphemeral()
        Platform.console.output("下载日志配置文件", style: .info)
        try await GameUtils.download(
            clientFile.url,
            progressHint: "\(clientFile.id)",
            targetDir: .clientLogConfig(version: clientInfo.version.id),
            hash: clientFile.sha1
        )
        Platform.console.popEphemeral()
        Platform.console.output("下载日志配置文件完成", style: .success)
    }
}
