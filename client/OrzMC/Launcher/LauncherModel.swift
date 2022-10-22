//
//  LauncherModel.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import Foundation
import Game

class LauncherModel: ObservableObject {
    
    @Published var versions = [String]()
    @Published var selectedVersion: String = ""
    @Published var username: String = ""
    
    
    @Published var showAlert: Bool = false
    var alertMessage: String? = nil
    var alertActionTip: String = "确定"
    
    func fetchGameVersions() async {
        let versions = Array(await GameUtils.releases()[0..<10])
        await MainActor.run {
            self.versions = versions
            if let firstVersion = self.versions.first {
                self.selectedVersion = firstVersion
            }
        }
    }
    
    func launch() async throws {
        guard !username.isEmpty else {
            await showAlert("没有输入玩家ID", actionTip: "到左上角输入玩家ID")
            return
        }
        guard let gameVersion = await GameUtils.releaseGameVersion(self.selectedVersion)?.first else {
            await showAlert("没有选择游戏版本", actionTip: "到左下解选择游戏版本")
            return
        }
        let clientInfo = ClientInfo(
            version: gameVersion,
            username: username,
            minMem: "512M",
            maxMem: "2G"
        )
        try await Launcher(clientInfo: clientInfo).start()
    }
    
    func showAlert(_ message: String, actionTip: String = "了解了") async {
        await MainActor.run {
            showAlert = true
            alertMessage = message
            alertActionTip = actionTip
        }
    }
}


let mockAppModel = LauncherModel()
