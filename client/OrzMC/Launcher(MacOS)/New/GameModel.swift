//
//  GameModel.swift
//  OrzMC
//
//  Created by joker on 4/27/24.
//

import SwiftUI
import Game
import Mojang

@Observable
final class GameModel {
    
    enum GameType: String, CaseIterable {
        case client, server
    }
    
    var versions = [Version]()
    
    var isLaunchingGame: Bool = false
    
    var selectedVersion: Version? {
        willSet {
            guard selectedVersion != newValue
            else {
                return
            }
            progress = 0.0
        }
    }
    
    var username: String = ""
    
    var gameType: GameType = .client {
        willSet {
            guard gameType != newValue
            else {
                return
            }
            progress = 0.0
        }
    }
        
    var progress: Double = 0.0
    
    var isFetchingGameVersions: Bool = false
    
    var isClient: Bool { gameType == .client }
    
    var isServer: Bool { gameType == .server }
    
}

extension GameModel {

    var detailTitle: String {
        guard let selectedVersion
        else {
            return "Minecraft"
        }
        return "Minecraft - \(selectedVersion.id)"
    }

}

extension GameModel {
    
    func fetchGameVersions() async throws {
        versions = try await Mojang.manifest?.versions ?? []
    }
    
    func startGame() {
        guard let selectedVersion
        else {
            return
        }
        
        Task {
            self.isLaunchingGame = true
            
            switch gameType {
            case .client:
                try await startClient(selectedVersion)
            case .server:
                try await startServer(selectedVersion)
            }
            
            self.isLaunchingGame = false
        }
    }
    
    func startClient(_ selectedVersion: Version) async throws {
        let clientInfo = ClientInfo(
            version: selectedVersion,
            username: username,
            minMem: "512M",
            maxMem: "2G"
        )
        var launcher = GUIClient(clientInfo: clientInfo, launcherModel: LauncherModel(), gameModel: self)
        try await launcher.start()
    }
    
    func startServer(_ selectedVersion: Version) async throws {
        let serverInfo = ServerInfo(
            version: selectedVersion.id,
            gui: false,
            debug: false,
            forceUpgrade: false,
            demo: false,
            minMem: "512M",
            maxMem: "2G",
            onlineMode: false,
            showJarHelpInfo: false,
            jarOptions: nil
        )
        let launcher = GUIServer(serverInfo: serverInfo, gameModel: self)
        try await launcher.start()
    }
}
