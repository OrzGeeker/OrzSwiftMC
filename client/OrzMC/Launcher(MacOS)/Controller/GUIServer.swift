//
//  GUIServer.swift
//  OrzMC
//
//  Created by joker on 4/27/24.
//

import Foundation
import PaperMCAPI
import Game

struct GUIServer: Server {
    
    let serverInfo: ServerInfo
    
    let serverType: GameType = .paper
    
    let gameModel: GameModel
    
    func start() async throws -> Process? {
        
        switch serverType {
        case .paper:
            return try await startPaperServer()
        case .vanilla:
            return try await VanillaServer(serverInfo: serverInfo).start()
        }
    }
    
    // MARK: PaperMC
    public func startPaperServer() async throws -> Process? {
        
        let version = serverInfo.version
        
        guard let (build, name, _) = try await client.latestBuildApplication(project: .paper, version: version)
        else {
            return nil
        }
        
        let workDirectory = GameDir.server(version: serverInfo.version, type: GameType.paper.rawValue)
        let serverJarFileDirPath = workDirectory.dirPath
        let dirURL = URL(filePath: serverJarFileDirPath)
        if !FileManager.default.fileExists(atPath: dirURL.path()) {
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
        }
        let jarFileURL = dirURL.appending(path: name)
        
        if !FileManager.default.fileExists(atPath: jarFileURL.path()) {
            guard let (jar, total) = try await client.downloadLatestBuild(project: .paper,
                                                                          version: version,
                                                                          build: build,
                                                                          name: name)
            else {
                return nil
            }
            
            var jarData = Data()
            for try await byteChunk in jar {
                jarData.append(Data(byteChunk))
                let progress = Double(jarData.count) / Double(total)
                gameModel.progress = progress
            }
            
            if !FileManager.default.fileExists(atPath: dirURL.path()) {
                try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
            }
            try jarData.write(to: jarFileURL, options: .atomic)
        }
        gameModel.progress = 1
        let process = try await launchServer(jarFileURL.path(), workDirectory: workDirectory, jarArgs: [
            "--online-mode=\(serverInfo.onlineMode ? "true" : "false")",
            "--nojline",
            "--noconsole"
        ])
        
        return process
    }
    
    private let client = PaperMCAPIClient()
}
