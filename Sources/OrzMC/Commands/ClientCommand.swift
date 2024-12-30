//
//  File.swift
//
//
//  Created by joker on 2022/1/14.
//

import ConsoleKit
import Game

struct ClientCommand: AsyncCommand {
    
    struct Signature: CommandSignature {
        @Flag(name: "debug", short: "d", help: "调试模式")
        var debug: Bool
        
        @Flag(name: "auth", short: "a", help: "是否验证正版帐号(默认不验证)")
        var authenticate: Bool
        
        @Option(name: "version", short: "v", help: "游戏版本号")
        var version: String?
        
        @Option(name: "username", short: "u", help: "登录用户名")
        var username: String?
        
        @Option(name: "ms", short: "s", help: "客户端运行使用的最小内存，默认为：512M")
        var minMem: String?
        
        @Option(name: "mx", short: "x", help: "客户端运行使用的最大内存，默认为：2G")
        var maxMem: String?
    }
    
    var help: String = "客户端相关命令"
    
    func run(using context: CommandContext, signature: Signature) async throws {
        
        let console = context.console
        
        let version = try await console.chooseGameVersion(signature.version)
        
        let username = signature.username ?? console.userInput(hint: "输入一个用户名：", completedHint: "游戏用户名：")
        
        let debug = signature.debug
        
        // 显示指定是否进行正版授权
        var accountName: String? = nil
        if signature.authenticate {
            accountName = console.userInput(hint: "输入正版帐号(如无可以直接回车)：")
            if let accountName = accountName, accountName.count > 0 {
                console.output("正版帐号：".consoleText(.success) + "\(accountName)".consoleText(.info))
                let accountPassword = console.userInput(hint: "输入正版密码((如无可以直接回车))：")
                if accountPassword.count > 0 {
                    let secureText = String(repeating: "*", count: accountPassword.count)
                    console.output("正版密码：".consoleText(.success) + secureText.consoleText(.info))
                }
            }
        }
        // ---
        
        let minMem = signature.minMem ?? "512M"
        let maxMem = signature.maxMem ?? "2G"
        
        // 参数收集完成
        let clientInfo = ClientInfo(
            version: version,
            username: username,
            debug: debug,
            authenticate: signature.authenticate,
            accountName: accountName,
            minMem: minMem,
            maxMem: maxMem,
            console: console
        )
        // 启动 Launcher
        var laucher = Launcher(clientInfo: clientInfo)
        try await laucher.start()
    }
}
