//
//  File.swift
//
//
//  Created by joker on 2022/1/14.
//

import ConsoleKit
import Dispatch
import JokerKits
import Game

struct ServerCommand: AsyncCommand {

    struct Signature: CommandSignature {
        @Flag(name: "debug", short: "d", help: "调试模式")
        var debug: Bool

        @Flag(name: "gui", short: "g", help: "服务器以GUI方式启动")
        var gui: Bool

        @Flag(name: "force_upgrade", short: "f", help: "强制升级地图")
        var forceUpgrade: Bool

        @Option(name: "type", short: "t", help: "服务器类型: paper/vanilla, 默认：paper")
        var type: String?

        @Option(name: "version", short: "v", help: "游戏版本号")
        var version: String?

        @Option(name: "ms", short: "s", help: "客户端运行使用的最小内存，默认为：1G")
        var minMem: String?

        @Option(name: "mx", short: "x", help: "客户端运行使用的最大内存，默认为：1G")
        var maxMem: String?

        @Option(name: "online-mode", short: "o", help: "服务端运行时是否使用Online模式，默认为：false")
        var onlineMode: Bool?

        @Flag(name: "jar-help", short: "j", help: "查看服务端jar包的帮助信息")
        var jarHelp: Bool

        @Option(name: "jar-opts", short: "e", help: "jar文件运行时额外选项, 字符串参数以 a: 开头，例如：--jar-opts \"a:--help\"")
        var jarOpts: String?

        @Flag(name: "demo", help: "演示模式")
        var demo: Bool

        @Flag(name: "kill-all", short: "k", help: "杀死所有正在运行的服务端")
        var killAll: Bool
    }

    var help: String = "服务端相关"
    func run(using context: CommandContext, signature: Signature) async throws {
        let killAll = signature.killAll
        guard !killAll
        else {
            try await Shell.stopAll()
            return
        }

        let version = try await OrzMC.chooseGameVersion(signature.version)
        let gui = signature.gui
        let debug = signature.debug
        let minMem = signature.minMem ?? "1G"
        let maxMem = signature.maxMem ?? "1G"
        let onlineMode = signature.onlineMode ?? false
        let forceUpgrade = signature.forceUpgrade
        let demo = signature.demo
        let jarHelp = signature.jarHelp
        let jarOpts = signature.jarOpts

        let serverInfo = ServerInfo(
            version:version.id,
            gui: gui,
            debug: debug,
            forceUpgrade: forceUpgrade,
            demo: demo,
            minMem: minMem,
            maxMem: maxMem,
            onlineMode: onlineMode,
            showJarHelpInfo: jarHelp,
            jarOptions: jarOpts
        )

        if let type = GameType(rawValue: signature.type ?? GameType.paper.rawValue) {
            Platform.console.success("服务器类型: \(type)")
            switch type {
            case .paper:
                try await PaperServer(serverInfo: serverInfo).start()
            case .vanilla:
                try await VanillaServer(serverInfo: serverInfo).start()
            }
        }
        else{
            Platform.console.success("服务器类型: \(GameType.paper)")
            try await PaperServer(serverInfo: serverInfo).start()
        }
    }
}
