//
//  LauncherModel.swift
//  OrzMC
//
//  Created by joker on 2022/10/19.
//

import Foundation
import Game
import Combine
import CoreData

class LauncherModel: ObservableObject {
    static let shared = LauncherModel()
    static let mockModel = LauncherModel()
    private init() {}
    
    /// 当前玩家ID
    @Published var username: String = ""
    
    /// 当前选中的游戏版本号
    @Published var selectedVersion: String = "" {
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
    @Published var versions = [String]()
    
    /// 当前选中的启动方式
    @Published var selectedProfileItem: String = "" {
        didSet {
            _ = try? GUILauncher.saveSelectedProfile(for: selectedVersion, with: selectedProfileItem)
        }
    }
    
    /// 客户端启动方式
    @Published var profileItems = [String]()
    
    /// 是否显示提醒Alert
    @Published var showAlert: Bool = false
        
    /// 启动器进度条进度值，取值 [0-1]
    @Published var launcherProgress: Double = 0
    
    /// 当前正在执行加载操作的源个数
    @Published private(set) var loadingItemCount: UInt = 0
    
    var showLoading: Bool { loadingItemCount > 0 }
    
    /// 绑定下载进度条
    var disposable: AnyCancellable? = nil
    lazy var progressSubject: PassthroughSubject<Double, Never> = {
        let subject = PassthroughSubject<Double, Never>()
        self.disposable = subject.receive(on: RunLoop.main).assign(to: \Self.launcherProgress, on: self)
        return subject
    }()
    
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
    
    /// 数据库CoreData托管
    let persistenceController = PersistenceController.shared
    
    /// 从数据库中获取上次启动时的信息
    lazy private var dbClientInfoItem: ClientInfoItem? = {
        let fetchRequest = NSFetchRequest<ClientInfoItem>(entityName: "ClientInfoItem")
        do {
            let clientInfoItem = try persistenceController.container.viewContext.fetch(fetchRequest).first
            return clientInfoItem
        } catch {
            return nil
        }
    }()
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
        
        var launcher = GUILauncher(clientInfo: clientInfo)
        await loadingItemStart()
        try await launcher.start()
        await loadingItemEnd()
        
        // 保存上一次启动信息到数据库中
        let viewContext = persistenceController.container.viewContext
        do {
            if let dbClientInfoItem = self.dbClientInfoItem {
                dbClientInfoItem.username = clientInfo.username
                dbClientInfoItem.gameVersion = clientInfo.version.id
            } else {
                NSEntityDescription.insertNewObject(forEntityName: "ClientInfoItem", into: viewContext)
            }
            try viewContext.save()
        }
        catch {
            
        }
    }
    
    func loadDbClientInfoItem() {
        guard let clientInfoItem = self.dbClientInfoItem else {
            return
        }
        if let username = clientInfoItem.username {
            self.username = username
        }
        if let gameVersion = clientInfoItem.gameVersion {
            self.selectedVersion = gameVersion
        }
    }
    
    /// 获取客户端所有可用Release版本
    func fetchGameVersions() async {
        await loadingItemStart()
        let versions = Array(await GameUtils.releases()[0..<10])
        await MainActor.run {
            self.versions = versions
            if let firstVersion = self.versions.first {
                self.selectedVersion = firstVersion
                
                if let profileItems = try? GUILauncher.launcherProfileItems(for: self.selectedVersion) {
                    self.profileItems = profileItems
                }
            }
        }
        await loadingItemEnd()
    }
    
    func refreshProfileItems(for version: String) async throws {
        let profileItems = try GUILauncher.launcherProfileItems(for: version)
        await MainActor.run {
            self.profileItems = profileItems
            if let firstItem = self.profileItems.first {
                self.selectedProfileItem = firstItem
            }
        }
    }
    
    func loadingItemStart() async {
        await MainActor.run {
            loadingItemCount += 1;
        }
        
    }
    
    func loadingItemEnd() async {
        await MainActor.run {
            loadingItemCount -= 1;
        }
    }
}
