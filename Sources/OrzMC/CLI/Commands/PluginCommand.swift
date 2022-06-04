//
//  PluginCommand.swift
//  
//
//  Created by wangzhizhou on 2022/3/28.
//

import ConsoleKit
import JokerKits
import Foundation
import PaperMC

struct PluginCommand: AsyncCommand {
    var help: String = "下载服务端需要的插件"
    struct Signature: CommandSignature {
        @Flag(name: "list", short: "l", help: "列出所有需要下载的插件信息")
        var list: Bool
        
        @Option(name: "output", short: "o", help: "下载插件后要保存到的目录路径")
        var output: String?
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        
        let console = context.console
        if signature.list {
            PluginInfo.allPlugins().compactMap {
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
            let loading = Platform.console.loadingBar(title: "正在下载插件")
            loading.start()
            let outpuFileDirURL = URL(fileURLWithPath: outputFilePath)
            try await Downloader.download(PluginInfo.downloadItemInfos(of: outpuFileDirURL))
            loading.succeed()
            console.output("文件已下载到目录：".consoleText(.info) + "\(outpuFileDirURL.path)".consoleText(.success))
        }
    }
}
