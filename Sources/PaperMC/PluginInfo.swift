//
//  PluginInfo.swift
//  
//
//  Created by wangzhizhou on 2022/3/28.
//

import JokerKits
import ConsoleKit
import Foundation

public struct PluginInfo: Codable, JsonRepresentable {
    public let name: String
    public let desc: String
    public let url: String
    public let site: String?
    public let docs: String?
    public let repo: String?
    public var enable: Bool = true
    public func download(_ console: Console, outputDirURL: URL) async {
        guard let url = URL(string: self.url) else {
            console.error("插件下载地址无效")
            return
        }
        let progressBar = console.progressBar(title: self.name)
        progressBar.start()
        return await withCheckedContinuation { continuation in
            Downloader().download(url) { progress, fileURL, error in
                if let error = error {
                    progressBar.fail()
                    console.error(error.localizedDescription)
                    continuation.resume()
                }
                else if let localFileURL = fileURL {
                    do {
                        let srcFilePath = localFileURL.path
                        let targetFilePath = outputDirURL.appendingPathComponent(self.name).appendingPathExtension("jar").path
                        try FileManager.moveFile(fromFilePath: srcFilePath, toFilePath: targetFilePath, overwrite: true)
                        progressBar.succeed()
                        continuation.resume()
                    }
                    catch let error {
                        progressBar.fail()
                        console.error(error.localizedDescription)
                        continuation.resume()
                    }
                }
                else {
                    progressBar.activity.currentProgress = progress
                }
            }
        }
    }
}

public extension PluginInfo {
    static func getAllPluginInfos() -> [PluginInfo] {
        return [
            PluginInfo(
                name: "GriefPrevention",
                desc: "防止服务器悲剧发生",
                url:  "https://dev.bukkit.org/projects/grief-prevention/files/latest",
                site: "https://dev.bukkit.org/projects/grief-prevention",
                docs: "https://docs.griefprevention.com/",
                repo: "https://github.com/TechFortress/GriefPrevention"),
            PluginInfo(
                name: "WorldEdit",
                desc: "地图编辑器",
                url:  "https://dev.bukkit.org/projects/worldedit/files/latest",
                site: "https://dev.bukkit.org/projects/worldedit",
                docs: "https://worldedit.enginehub.org/en/latest/",
                repo: "https://github.com/EngineHub/WorldEdit"),
            PluginInfo(
                name: "WorldGuard",
                desc: "地图区域保护",
                url:  "https://dev.bukkit.org/projects/worldguard/files/latest",
                site: "https://dev.bukkit.org/projects/worldguard",
                docs: "https://worldguard.enginehub.org/en/latest/",
                repo: "https://github.com/EngineHub/WorldGuard"),
            PluginInfo(
                name: "EssentialsX",
                desc: "扩展命令大全",
                url:  "https://dev.bukkit.org/projects/essentialsx/files/latest",
                site: "https://essentialsx.net",
                docs: "https://essentialsx.net/wiki/Home.html",
                repo: "https://github.com/EssentialsX/Essentials"),
            PluginInfo(
                name: "GetMeHome",
                desc: "快速回家命令",
                url: "https://dev.bukkit.org/projects/getmehome/files/latest",
                site: "https://dev.bukkit.org/projects/getmehome",
                docs: nil,
                repo: "https://github.com/chuushi/GetMeHome"),
            PluginInfo(
                name: "SkinsRestorerX",
                desc: "离线服皮肤管理",
                url: "https://github.com/SkinsRestorer/SkinsRestorerX/releases/latest/download/SkinsRestorer.jar",
                site: "https://skinsrestorer.net/",
                docs: "https://github.com/SkinsRestorer/SkinsRestorerX/wiki",
                repo: "https://github.com/SkinsRestorer/SkinsRestorerX"),
            PluginInfo(
                name: "DeadChest",
                desc: "死亡掉落物品箱",
                url:  "https://dev.bukkit.org/projects/dead-chest/files/latest",
                site: "https://dev.bukkit.org/projects/dead-chest",
                docs: nil,
                repo: "https://github.com/apavarino/Deadchest"),
            PluginInfo(
                name: "HolographicDisplays",
                desc: "全息显示",
                url:  "https://dev.bukkit.org/projects/holographic-displays/files/latest",
                site: "https://dev.bukkit.org/projects/holographic-displays",
                docs: "https://filoghost.me/docs/holographic-displays",
                repo: "https://github.com/filoghost/HolographicDisplays"),
            PluginInfo(
                name: "GeyserMC",
                desc: "基岩版客户端联机Java版服务器",
                url:  "https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar",
                site: "https://geysermc.org/",
                docs: "https://wiki.geysermc.org/geyser/",
                repo: "https://github.com/GeyserMC/Geyser"),
            PluginInfo(
                name: "SimpleVoiceChat",
                desc: "语音聊天",
                url:  "https://www.curseforge.com/minecraft/bukkit-plugins/simple-voice-chat/download",
                site: "https://www.curseforge.com/minecraft/bukkit-plugins/simple-voice-chat",
                docs: "https://modrepo.de/minecraft/voicechat/wiki",
                repo: "https://github.com/henkelmax/simple-voice-chat",
                enable: false),
            // MARK: 不在被维护
            PluginInfo(
                name: "PlugMan",
                desc: "服务端插件管理器，无需重启服务器",
                url:  "https://dev.bukkit.org/projects/plugman/files/latest",
                site: "https://dev.bukkit.org/projects/plugman",
                docs: "https://github.com/ryan-clancy/PlugMan/blob/master/README.md",
                repo: "https://github.com/ryan-clancy/PlugMan"),
            // MARK: 没有源码
            PluginInfo(
                name: "BackOnDeath",
                desc: "快速返回死亡地点",
                url:  "https://dev.bukkit.org/projects/back-ondeath/files/latest",
                site: "https://dev.bukkit.org/projects/back-ondeath",
                docs: "nil",
                repo: "nil"),
            
            // MARK: 下面的无法每次获取最新版本
            PluginInfo(
                name: "LoginSecurity",
                desc: "离线服帐号管理",
                url:  "https://github.com/lenis0012/LoginSecurity-2/releases/download/v3.1/LoginSecurity-3.1-Spigot.jar",
                site: "https://www.spigotmc.org/resources/loginsecurity.19362/",
                docs: "https://github.com/lenis0012/LoginSecurity-2/wiki",
                repo: "https://github.com/lenis0012/LoginSecurity-2"),
            PluginInfo(
                name: "LuckPerms",
                desc: "玩家权限管理",
                url:  "https://ci.lucko.me/job/LuckPerms/1423/artifact/bukkit/loader/build/libs/LuckPerms-Bukkit-5.4.15.jar",
                site: "https://luckperms.net/",
                docs: "https://luckperms.net/wiki/Home",
                repo: "https://github.com/LuckPerms/LuckPerms"),
            PluginInfo(
                name: "BlueMap",
                desc: "Web端服务器地图3D浏览",
                url:  "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v1.7.2/BlueMap-1.7.2-spigot.jar",
                site: "https://bluemap.bluecolored.de/",
                docs: "https://bluemap.bluecolored.de/wiki/",
                repo: "https://github.com/BlueMap-Minecraft/BlueMap"),
            PluginInfo(
                name: "ViaVersion",
                desc: "老版服务器兼容新版本客户端登录",
                url:  "https://www.spigotmc.org/resources/viaversion.19254/download?version=443043",
                site: "https://www.spigotmc.org/resources/viaversion.19254/",
                docs: "https://viaversion.atlassian.net/wiki/spaces/VIAVERSION/overview",
                repo: "https://github.com/ViaVersion/ViaVersion"),
            PluginInfo(
                name: "ViaBackwards",
                desc: "服务端兼容旧版本客户端登录",
                url:  "https://www.spigotmc.org/resources/viabackwards.27448/download?version=445618",
                site: "https://www.spigotmc.org/resources/viabackwards.27448/",
                docs: nil,
                repo: "https://github.com/ViaVersion/ViaBackwards"),
            PluginInfo(
                name: "Vault",
                desc: "提供权限、聊天、经济API供其它插件使用",
                url:  "https://www.spigotmc.org/resources/vault.34315/download?version=344916",
                site: "https://www.spigotmc.org/resources/vault.34315/",
                docs: nil,
                repo: "https://github.com/milkbowl/Vault"),
            // MARK: 下面是暂时不用的插件
            PluginInfo(
                name: "Dynmap",
                desc: "Web端服务器地图浏览插件",
                url:  "https://dev.bukkit.org/projects/dynmap/files/latest",
                site: "https://dev.bukkit.org/projects/dynmap",
                docs: "https://github.com/webbukkit/dynmap/wiki",
                repo: "https://github.com/webbukkit/dynmap",
                enable: false),
            PluginInfo(
                name: "FloodGate",
                desc: "基岩版客户端联机Java版服务器",
                url:  "https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/target/floodgate-spigot.jar",
                site: "https://geysermc.org/",
                docs: "https://wiki.geysermc.org/geyser/",
                repo: "https://github.com/GeyserMC/Geyser",
                enable: false),
        ].filter { $0.enable }
    }
}
