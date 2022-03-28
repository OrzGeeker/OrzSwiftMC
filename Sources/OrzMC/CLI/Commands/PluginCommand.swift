//
//  PluginCommand.swift
//  
//
//  Created by wangzhizhou on 2022/3/28.
//

import ConsoleKit
import JokerKits
import Foundation

struct PluginCommand: Command {
    var help: String = "下载服务端需要的插件"
    struct Signature: CommandSignature {
        @Flag(name: "list", short: "l", help: "列出所有需要下载的插件信息")
        var list: Bool
        
        @Option(name: "output", short: "o", help: "下载插件后要保存到的目录路径")
        var output: String?
    }
    func run(using context: CommandContext, signature: Signature) throws {
        let console = context.console
        if signature.list {
            plugins.compactMap {
                try? $0.jsonRepresentation()
            }
            .forEach {
                console.info($0, newLine: true)
            }
        }
        else {
            guard let output = signature.output, output.isDirPath() else {
                console.error("未指定插件存放目录路径")
                console.info("选项: -o <file_path> 指定下载文件存放路径")
                return
            }
            try DispatchGroup().syncExecAndWait {
                for plugin in plugins {
                    await plugin.download(console, output: output)
                }
            } errorClosure: { error in
                console.error(error.localizedDescription)
            }
        }
    }
}

struct PluginInfo: Codable, JsonRepresentable {
    let name: String
    let desc: String
    let url: String
    let site: String?
    let docs: String?
    let repo: String?
    func download(_ console: Console, output: String) async {
        guard let url = URL(string: self.url) else {
            console.error("插件下载地址无效")
            return
        }
        let progressBar = console.progressBar(title: self.name)
        progressBar.start()
        return await withCheckedContinuation { continuation in
            Downloader().download(url) { progress, filePath in
                if let localFilePath = filePath {
                    progressBar.succeed()
                    do {
                        try FileManager.moveFile(fromFilePath: localFilePath.absoluteString, toFilePath: output, overwrite: false)
                        continuation.resume()
                    }
                    catch let e {
                        console.error(e.localizedDescription)
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

extension PluginCommand {
    var plugins: [PluginInfo] {
        [
            PluginInfo(
                name: "Grief Prevention",
                desc: "防止服务器悲剧发生",
                url:  "https://dev.bukkit.org/projects/grief-prevention/files/latest",
                site: "https://dev.bukkit.org/projects/grief-prevention",
                docs: "https://docs.griefprevention.com/",
                repo: "https://github.com/TechFortress/GriefPrevention"),
        ]
    }
}
