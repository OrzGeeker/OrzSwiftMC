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
        let workDirectory = GameDir.server(version: serverInfo.version, type: GameType.paper.rawValue)
        let serverJarFileDirPath = workDirectory.dirPath
        let progressBar = Platform.console.progressBar(title: "正在下载服务端文件")
        progressBar.start()
        guard let (name, jar, total) = try await PaperMC.apiV2.downloadLatestBuild(project: .paper, version: serverInfo.version)
        else {
            progressBar.fail()
            return
        }
        var jarData = Data()
        for try await byteChunk in jar {
            jarData.append(Data(byteChunk))
            let progress = Double(jarData.count) / Double(total)
            progressBar.activity.currentProgress = progress
        }
        progressBar.succeed()
        let dirURL = URL(filePath: serverJarFileDirPath)
        if !FileManager.default.fileExists(atPath: dirURL.path()) {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
        let jarFileURL = dirURL.appending(path: name)
        try jarData.write(to: jarFileURL, options: .atomic)
        try await launchServer(jarFileURL.path(), workDirectory: workDirectory, jarArgs: [
            "--online-mode=\(serverInfo.onlineMode ? "true" : "false")",
//            "--nojline",
//            "--noconsole"
        ])
    }
}
