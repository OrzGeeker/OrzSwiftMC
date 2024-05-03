//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation
import Mojang
import JokerKits
import Utils

public extension Client {
    /// 从客户端版本清单文件中分析出要下载的资源信息
    /// - Returns: 需要下载的资源信息数组
    func generateDownloadItemInfos() async throws -> [DownloadItemInfo] {
        var downloadItems = [DownloadItemInfo]()
        
        let gameInfo = try await self.clientInfo.version.gameInfo
        guard let client = gameInfo?.downloads.client,
              let assetIndex = gameInfo?.assetIndex,
              let objects = try await assetIndex.assetInfo?.objects,
              let libraries = gameInfo?.libraries,
              let clientLogCfgFile = gameInfo?.logging.client.file
        else { return downloadItems }
        
        // 游戏版本信息JSON文件
        if let sourceURL = clientInfo.version.url {
            let jsonFileName = sourceURL.lastPathComponent
            let jsonFilePath = GameDir.clientVersion(version: clientInfo.version.id).filePath(jsonFileName)
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            let jsonFileItme = DownloadItemInfo(sourceURL: sourceURL, dstFileURL: jsonFileURL)
            downloadItems.append(jsonFileItme)
        }
        
        // 游戏客户端Jar文件
        let clientJarFileName = [clientInfo.version.id, client.url.pathExtension].joined(separator: ".")
        let clientJarFilePath = GameDir.clientVersion(version: clientInfo.version.id).filePath(clientJarFileName)
        let clientJarFileURL = URL(fileURLWithPath: clientJarFilePath)
        let clientJarItem = DownloadItemInfo(sourceURL: client.url, dstFileURL: clientJarFileURL, hash: client.sha1, hashType: .sha1)
        downloadItems.append(clientJarItem)
        
        // 游戏客户端资源索引文件
        let indexFileName = assetIndex.url.lastPathComponent
        let indexFilePath = GameDir.assetsIdx(version: clientInfo.version.id).filePath(indexFileName)
        let indexFileURL = URL(fileURLWithPath: indexFilePath)
        let indexFileItem = DownloadItemInfo(sourceURL: assetIndex.url, dstFileURL: indexFileURL, hash: assetIndex.sha1, hashType: .sha1)
        downloadItems.append(indexFileItem)
        
        // 游戏客户端资源对象文件
        for filename in objects.keys {
            guard let info = objects[filename]
            else {
                continue
            }
            let assetObjURL = Mojang.assetObjURL(info.filePath())
            let assetFilePath = GameDir.assetsObj(version: clientInfo.version.id, path: info.dirPath()).filePath(assetObjURL.lastPathComponent)
            let assetFileURL = URL(fileURLWithPath: assetFilePath)
            let assetFileItem = DownloadItemInfo(sourceURL: assetObjURL, dstFileURL: assetFileURL, hash: info.hash, hashType: .sha1)
            downloadItems.append(assetFileItem)
        }
        
        // 游戏客户端依赖库文件
        for lib in libraries {
            var artifact = lib.downloads.artifact
            let dirPath = NSString(string: artifact.path).deletingLastPathComponent
            var targetDir = GameDir.libraryObj(version: clientInfo.version.id, path: dirPath)
            
            let currentOSName = Platform.os.platformName()
            if let natives = lib.natives, let nativeClassifier = natives[currentOSName], let nativeArtifact = lib.downloads.classifiers?[nativeClassifier] {
                artifact = nativeArtifact
                targetDir = GameDir.clientVersionNative(version: clientInfo.version.id)
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
                continue
            }
            
            let libFilePath = targetDir.filePath(artifact.url.lastPathComponent)
            let libFileURL = URL(fileURLWithPath: libFilePath)
            let libFileItem = DownloadItemInfo(sourceURL: artifact.url, dstFileURL: libFileURL, hash: artifact.sha1, hashType: .sha1)
            downloadItems.append(libFileItem)
        }
        
        // 游戏客户端日志配置文件
        let clientLogCfgFilePath = GameDir.clientLogConfig(version: clientInfo.version.id).filePath(clientLogCfgFile.url.lastPathComponent)
        let clientLogCfgFileURL = URL(fileURLWithPath: clientLogCfgFilePath)
        let clientLogCfgFileItem = DownloadItemInfo(sourceURL: clientLogCfgFile.url, dstFileURL: clientLogCfgFileURL, hash: clientLogCfgFile.sha1, hashType: .sha1)
        downloadItems.append(clientLogCfgFileItem)
        
        // 返回所有需要下载的项目信息
        return downloadItems
    }
}
