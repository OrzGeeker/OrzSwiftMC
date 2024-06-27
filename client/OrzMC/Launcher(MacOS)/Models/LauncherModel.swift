//
//  LauncherModel.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import Foundation
import Game
import CoreData

@MainActor
@Observable
class LauncherModel {
    
    static let shared =  LauncherModel()
    
    /// 当前玩家ID
    var username: String = ""
    
    /// 当前选中的游戏版本号
    var selectedVersion: String = "" {
        willSet {
            guard newValue != selectedVersion else {
                return
            }
            
            Task {
                try await refreshProfileItems(for: selectedVersion)
            }
        }
    }
    
    /// 所有可选游戏版本号
    var versions = [String]()
    
    /// 当前选中的启动方式
    var selectedProfileItem: String = "" {
        didSet {
            _ = try? GUIClient.saveSelectedProfile(for: selectedVersion, with: selectedProfileItem)
        }
    }
    
    /// 客户端启动方式
    var profileItems = [String]()
    
    /// 是否显示提醒Alert
    var showAlert: Bool = false
        
    /// 启动器进度条进度值，取值 [0-1]
    var launcherProgress: Double = 0
    
    var showLoading: Bool = false

    /// 当前客户端的启动信息
    var clientInfo: ClientInfo? = nil
    
    /// 提醒消息
    var alertMessage: String? = nil {
        didSet {
            showAlert = true
        }
    }
    
    /// 提醒按钮文案
    var alertActionTip: String = "确定"
    
    /// 窗口大小
    let windowSize = CGSize(width: 3840.0/5.0, height: 1712.0/5.0)


    var isPluginsDownloading: Bool = false
}

// MARK: Alert
extension LauncherModel {
    
    /// 显示提醒弹窗
    /// - Parameters:
    ///   - message: 提醒文案
    ///   - actionTip: 按钮标题文案
    func showAlert(_ message: String, actionTip: String = "了解了") async {
        await MainActor.run {
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
        
        self.clientInfo = ClientInfo(
            version: gameVersion,
            username: username,
            minMem: "512M",
            maxMem: "2G"
        )
        
        guard let clientInfo = self.clientInfo else {
            return
        }
        
        var launcher = GUIClient(clientInfo: clientInfo, launcherModel: self, gameModel: GameModel())
        try await launcher.start()
    }
    
    /// 获取客户端所有可用Release版本
    func fetchGameVersions() async {
        let versions = Array(await GameUtils.releases()[0..<10])
        await MainActor.run {
            self.versions = versions
            if let firstVersion = self.versions.first {
                self.selectedVersion = firstVersion
                
                if let profileItems = try? GUIClient.launcherProfileItems(for: self.selectedVersion) {
                    self.profileItems = profileItems
                }
            }
        }
    }
    
    func refreshProfileItems(for version: String) async throws {
        let profileItems = try GUIClient.launcherProfileItems(for: version)
        await MainActor.run {
            self.profileItems = profileItems
            if let firstItem = self.profileItems.first {
                self.selectedProfileItem = firstItem
            }
        }
    }

    func updateLauncherProgress(_ progress: Double) {
        self.launcherProgress = progress
    }
}


extension LauncherModel {
    var externalLinks: [(title: String, systemImageName: String, link:URL)] {
        return [
            (title: "主页", systemImageName: "house.fill", "minecraft".jokerhubURL),
            (title: "地图", systemImageName: "map.fill", "world".jokerhubURL),
            (title: "自研插件", systemImageName: "powerplug.fill", URL(string: "https://github.com/OrzGeeker/OrzMCPlugin")!),
        ]
    }
}

extension String {
    var jokerhubURL: URL {
        return URL(string: "https://\(self).jokerhub.cn")!
    }
}
