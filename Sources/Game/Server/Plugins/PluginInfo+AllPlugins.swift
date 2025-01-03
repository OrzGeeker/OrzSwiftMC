//
//  PluginInfo+AllPlugins.swift
//  
//
//  Created by wangzhizhou on 2022/3/29.
//

import JokerKits
import ConsoleKit
import Foundation

public extension PluginInfo {
    
    static func allPlugins() -> [PluginInfo] {
        return [
            PluginInfo(
                name: "GriefPrevention",
                desc: "防止服务器悲剧发生",
                url:  "https://dev.bukkit.org/projects/grief-prevention/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/grief-prevention",
                docs: "https://docs.griefprevention.com/",
                repo: "https://github.com/TechFortress/GriefPrevention"),
            PluginInfo(
                name: "WorldEdit",
                desc: "地图编辑器",
                url:  "https://dev.bukkit.org/projects/worldedit/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/worldedit",
                docs: "https://worldedit.enginehub.org/en/latest/",
                repo: "https://github.com/EngineHub/WorldEdit"),
            PluginInfo(
                name: "WorldGuard",
                desc: "地图区域保护",
                url:  "https://dev.bukkit.org/projects/worldguard/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/worldguard",
                docs: "https://worldguard.enginehub.org/en/latest/",
                repo: "https://github.com/EngineHub/WorldGuard"),
            PluginInfo(
                name: "EssentialsX",
                desc: "扩展命令大全",
                url:  "https://dev.bukkit.org/projects/essentialsx/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://essentialsx.net",
                docs: "https://essentialsx.net/wiki/Home.html",
                repo: "https://github.com/EssentialsX/Essentials"),
            PluginInfo(
                name: "GetMeHome",
                desc: "快速回家命令",
                url: "https://dev.bukkit.org/projects/getmehome/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/getmehome",
                docs: nil,
                repo: "https://github.com/chuushi/GetMeHome"),
            PluginInfo(
                name: "SkinsRestorerX",
                desc: "离线服皮肤管理",
                url: "https://github.com/SkinsRestorer/SkinsRestorerX/releases/latest/download/SkinsRestorer.jar",
                type: .paper,
                downloadType: .automatic,
                site: "https://skinsrestorer.net/",
                docs: "https://github.com/SkinsRestorer/SkinsRestorerX/wiki",
                repo: "https://github.com/SkinsRestorer/SkinsRestorerX"),
            PluginInfo(
                name: "DeadChest",
                desc: "死亡掉落物品箱",
                url:  "https://dev.bukkit.org/projects/dead-chest/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/dead-chest",
                docs: nil,
                repo: "https://github.com/apavarino/Deadchest"),
            PluginInfo(
                name: "GeyserMC",
                desc: "基岩版客户端联机Java版服务器",
                url:  "https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot",
                type: .spigot,
                downloadType: .automatic,
                site: "https://geysermc.org/",
                docs: "https://wiki.geysermc.org/geyser/",
                repo: "https://github.com/GeyserMC/Geyser"),
            PluginInfo(
                name: "spark",
                desc: "适用于Mincraft客户端、服务端、代理的性能分析工具",
                url: "https://ci.lucko.me/job/spark/375/artifact/spark-bukkit/build/libs/spark-1.10.37-bukkit.jar",
                type: .bukkit,
                downloadType: .manual,
                site: "https://spark.lucko.me/",
                docs: "https://spark.lucko.me/docs",
                repo: "https://github.com/lucko/spark"),
            // MARK: 没有源码
            PluginInfo(
                name: "BackOnDeath",
                desc: "快速返回死亡地点",
                url:  "https://dev.bukkit.org/projects/back-ondeath/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/back-ondeath",
                docs: "nil",
                repo: "nil"),
            // MARK: 下面的无法每次获取最新版本
            PluginInfo(
                name: "LoginSecurity",
                desc: "离线服帐号管理",
                url:  "https://github.com/lenis0012/LoginSecurity-2/releases/download/v3.1.1/LoginSecurity-3.1.1-Spigot.jar",
                type: .spigot,
                downloadType: .manual,
                site: "https://www.spigotmc.org/resources/loginsecurity.19362/",
                docs: "https://github.com/lenis0012/LoginSecurity-2/wiki",
                repo: "https://github.com/lenis0012/LoginSecurity-2"),
            PluginInfo(
                name: "LuckPerms",
                desc: "玩家权限管理",
                url:  "https://download.luckperms.net/1512/bukkit/loader/LuckPerms-Bukkit-5.4.98.jar",
                type: .bukkit,
                downloadType: .manual,
                site: "https://luckperms.net/",
                docs: "https://luckperms.net/wiki/Home",
                repo: "https://github.com/LuckPerms/LuckPerms"),
            PluginInfo(
                name: "BlueMap",
                desc: "Web端服务器地图3D浏览",
                url:  "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v3.14/BlueMap-3.14-spigot.jar",
                type: .spigot,
                downloadType: .manual,
                site: "https://bluemap.bluecolored.de/",
                docs: "https://bluemap.bluecolored.de/wiki/",
                repo: "https://github.com/BlueMap-Minecraft/BlueMap"),
            PluginInfo(
                name: "ViaVersion",
                desc: "老版服务器兼容新版本客户端登录",
                url:  "https://www.spigotmc.org/resources/viaversion.19254/download?version=499424",
                type: .spigot,
                downloadType: .needAuth,
                site: "https://www.spigotmc.org/resources/viaversion.19254/",
                docs: "https://viaversion.atlassian.net/wiki/spaces/VIAVERSION/overview",
                repo: "https://github.com/ViaVersion/ViaVersion"),
            PluginInfo(
                name: "ViaBackwards",
                desc: "服务端兼容旧版本客户端登录",
                url:  "https://www.spigotmc.org/resources/viabackwards.27448/download?version=499649",
                type: .spigot,
                downloadType: .needAuth,
                site: "https://www.spigotmc.org/resources/viabackwards.27448/",
                docs: nil,
                repo: "https://github.com/ViaVersion/ViaBackwards"),
            PluginInfo(
                name: "Vault",
                desc: "提供权限、聊天、经济API供其它插件使用",
                url:  "https://www.spigotmc.org/resources/vault.34315/download?version=344916",
                type: .spigot,
                downloadType: .needAuth,
                site: "https://www.spigotmc.org/resources/vault.34315/",
                docs: nil,
                repo: "https://github.com/milkbowl/Vault"),
            // MARK: 下面是暂时不用的插件
            PluginInfo(
                name: "SimpleVoiceChat",
                desc: "语音聊天",
                url:  "https://www.curseforge.com/minecraft/bukkit-plugins/simple-voice-chat/download/4438347",
                type: .bukkit,
                downloadType: .manual,
                site: "https://www.curseforge.com/minecraft/bukkit-plugins/simple-voice-chat",
                docs: "https://modrepo.de/minecraft/voicechat/wiki",
                repo: "https://github.com/henkelmax/simple-voice-chat",
                enable: false),
            PluginInfo(
                name: "PlasmoVoice",
                desc: "游戏语音通话",
                url:  "https://www.spigotmc.org/resources/plasmo-voice-server.91064/download?version=491553",
                type: .spigot,
                downloadType: .needAuth,
                site: "https://www.spigotmc.org/resources/plasmo-voice-server.91064/",
                docs: "https://github.com/plasmoapp/plasmo-voice/wiki/",
                repo: "https://github.com/plasmoapp/plasmo-voice",
                enable: false),
            PluginInfo(
                name: "Dynmap",
                desc: "Web端服务器地图浏览插件",
                url:  "https://dev.bukkit.org/projects/dynmap/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/dynmap",
                docs: "https://github.com/webbukkit/dynmap/wiki",
                repo: "https://github.com/webbukkit/dynmap",
                enable: false),
            PluginInfo(
                name: "FloodGate",
                desc: "基岩版客户端联机Java版服务器",
                url:  "https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/bungee",
                type: .spigot,
                downloadType: .automatic,
                site: "https://geysermc.org/",
                docs: "https://wiki.geysermc.org/geyser/",
                repo: "https://github.com/GeyserMC/Geyser",
                enable: false),
            PluginInfo(
                name: "HolographicDisplays",
                desc: "全息显示",
                url:  "https://dev.bukkit.org/projects/holographic-displays/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                site: "https://dev.bukkit.org/projects/holographic-displays",
                docs: "https://filoghost.me/docs/holographic-displays",
                repo: "https://github.com/filoghost/HolographicDisplays",
                enable: false),
            // MARK: 不在被维护
            PluginInfo(
                name: "PlugMan",
                desc: "服务端插件管理器，无需重启服务器",
                url:  "https://dev.bukkit.org/projects/plugman/files/latest",
                type: .bukkit,
                downloadType: .automatic,
                status: .deprecated,
                site: "https://dev.bukkit.org/projects/plugman",
                docs: "https://github.com/ryan-clancy/PlugMan/blob/master/README.md",
                repo: "https://github.com/ryan-clancy/PlugMan",
                enable: false),
        ].filter { $0.enable && !$0.url.isEmpty && $0.downloadType != .needAuth }
    }
    
    static func downloadItemInfos(of outputDirURL: URL, console: any Console) -> [DownloadItemInfo] {
        return allPlugins().compactMap { pluginInfo in
            guard let sourceURL = URL(string: pluginInfo.url) else {
                console.error("插件\(pluginInfo.name)下载地址无效")
                return nil
            }
            let dstFileURL = outputDirURL.appendingPathComponent(pluginInfo.name).appendingPathExtension("jar")
            return DownloadItemInfo(sourceURL: sourceURL, dstFileURL: dstFileURL)
        }
    }
}
