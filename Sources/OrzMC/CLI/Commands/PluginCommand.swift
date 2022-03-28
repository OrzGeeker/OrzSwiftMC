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
            let outputPath = signature.output ?? Bundle.main.executablePath
            guard let outputFilePath = outputPath else {
                console.error("未指定文件存放路径")
                return
            }
            
            var outpuFileDirURL = URL(fileURLWithPath: outputFilePath)
            if !outpuFileDirURL.path.isDirPath() {
                outpuFileDirURL.deleteLastPathComponent()
            }
            
            try DispatchGroup().syncExecAndWait {
                for plugin in plugins {
                    await plugin.download(console, outputDirURL: outpuFileDirURL)
                }
                console.output("文件已下载到目录：".consoleText(.info) + "\(outpuFileDirURL.path)".consoleText(.success))
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
    func download(_ console: Console, outputDirURL: URL) async {
        guard let url = URL(string: self.url) else {
            console.error("插件下载地址无效")
            return
        }
        let progressBar = console.progressBar(title: self.name)
        progressBar.start()
        return await withCheckedContinuation { continuation in
            Downloader().download(url) { progress, fileURL in
                if let localFileURL = fileURL {
                    progressBar.succeed()
                    do {
                        let srcFilePath = localFileURL.path
                        let targetFilePath = outputDirURL.appendingPathComponent(self.name).appendingPathExtension("jar").path
                        try FileManager.moveFile(fromFilePath: srcFilePath, toFilePath: targetFilePath, overwrite: true)
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
