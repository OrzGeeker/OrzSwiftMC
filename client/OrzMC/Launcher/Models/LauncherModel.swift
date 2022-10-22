//
//  LauncherModel.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import Foundation
import Game

let mockAppModel = LauncherModel()

class LauncherModel: ObservableObject {
    
    /// 所有可选游戏版本号
    @Published var versions = [String]()
    
    /// 当前选中的游戏版本号
    @Published var selectedVersion: String = ""
    
    /// 当前玩家ID
    @Published var username: String = ""
    
    /// 是否显示提醒Alert
    @Published var showAlert: Bool = false
    
    /// 提醒消息
    var alertMessage: String? = nil
    
    /// 提醒按钮文案
    var alertActionTip: String = "确定"
    
    
    /// 启动器进度条进度值，取值 [0-1]
    @Published var launcherProgress: Float = 0.5
    
}

// MARK: Alert
extension LauncherModel {
    
    /// 显示提醒弹窗
    /// - Parameters:
    ///   - message: 提醒文案
    ///   - actionTip: 按钮标题文案
    func showAlert(_ message: String, actionTip: String = "了解了") async {
        await MainActor.run {
            showAlert = true
            alertMessage = message
            alertActionTip = actionTip
        }
    }
}

// MARK: Client
extension LauncherModel {
    
    /// 启动客户端
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
    
    /// 获取客户端所有可用Release版本
    func fetchGameVersions() async {
        let versions = Array(await GameUtils.releases()[0..<10])
        await MainActor.run {
            self.versions = versions
            if let firstVersion = self.versions.first {
                self.selectedVersion = firstVersion
            }
        }
    }
}
