//
//  File.swift
//  
//
//  Created by joker on 2022/1/3.
//

import PaperMC
import JokerKits
import Foundation
import ConsoleKit

enum PaperServerError: Error {
    case versionRespFailed
    case convertBuildStringFailed
    case buildRespFailed
    case applicationFailed
    case downloadURLFailed
}

public struct PaperServer: Server {
    
    let serverInfo: ServerInfo
    
    public init(serverInfo: ServerInfo) {
        self.serverInfo = serverInfo
    }
        
    public func start() async throws {
        
        let versionAPI = PaperMC.api.projects("paper").versions(serverInfo.version)
        guard let versionData = try await versionAPI.getData
        else {
            throw PaperServerError.versionRespFailed
        }
        
        let decoder = PaperMC.api.jsonDecoder
        let version = try decoder.decode(VersionResponse.self, from: versionData)
        
        guard let latestBuild = version.builds.last
        else {
            throw PaperServerError.convertBuildStringFailed
        }
        let buildAPI = versionAPI.builds(latestBuild)
        guard let buildData = try await buildAPI.getData
        else {
            throw PaperServerError.buildRespFailed
        }
        
        let build = try decoder.decode(BuildResponse.self, from: buildData)
        
        
        guard let application = build.downloads["application"]
        else {
            throw PaperServerError.applicationFailed
        }
        
        guard let downloadURL = buildAPI.downloads(application.name).url
        else {
            throw PaperServerError.downloadURLFailed
        }
                
        let serverJarFileName = downloadURL.lastPathComponent
        let serverJarFileDirPath = GameDir.server(version: serverInfo.version, type: GameType.paper.rawValue)
        let serverJarFilePath = serverJarFileDirPath.filePath(serverJarFileName)
        let serverJarFileURL = URL(fileURLWithPath: serverJarFilePath)
        let serverJarFileItem = DownloadItemInfo(sourceURL: downloadURL, dstFileURL: serverJarFileURL, hash: application.sha256, hashType: .sha256)
        
        let progressBar = Platform.console.progressBar(title: "正在下载服务端文件")
        try await Downloader.download(serverJarFileItem, progressBar: progressBar)
        try await launchServer(serverJarFilePath, workDirectory: serverJarFileDirPath, jarArgs: [
            "--online-mode=\(serverInfo.onlineMode ? "true" : "false")",
            "--noconsole"
        ])
    }
}
