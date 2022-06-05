//
//  File.swift
//  
//
//  Created by joker on 2022/4/4.
//

import Foundation
import ConsoleKit
import Fabric
import JokerKits

struct FabricCommand: AsyncCommand {
    var help: String = "安装Fabric"
    
    struct Signature: CommandSignature {
        @Flag(name: "server", short: "s", help: "安装服务端Fabric，不指定默认安装客户端Fabric")
        var server: Bool
        
        @Option(name: "installer", short: "i", help: "Fabric安装器文件下载URL链接或者本地文件URL")
        var installer: String?
        
        @Option(name: "version", short: "v", help: "指定游戏版本号")
        var version: String?
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        
        if let installer = signature.installer, let version = signature.version, let installerURL = URL(string: installer), version.count > 0 {
            let installType = signature.server ? Fabric.InstallType.server : Fabric.InstallType.client
            let installDir = signature.server ? GameDir.server(version: version) : GameDir.client(version: version)
            if installerURL.isFileURL {
                try await Fabric.installFabric(
                    installType,
                    installerFileURL: installerURL,
                    installDir: installDir.dirPath,
                    version: version)
            }
            else {
                let (downloadURLTask, downloadProgressStream) = Downloader.download(installerURL)
                
                // 进度条展示
                let progressBar = context.console.progressBar(title: installerURL.lastPathComponent)
                progressBar.start()
                for try await progress in downloadProgressStream {
                    progressBar.activity.currentProgress = progress.fractionCompleted
                }
                progressBar.succeed()
                
                // Fabric安装器
                let localFileURL = try await downloadURLTask.value
                try await Fabric.installFabric(
                    installType,
                    installerFileURL: localFileURL,
                    installDir: installDir.dirPath,
                    version: version)
            }
        }
        else {
            var context = context
            outputHelp(using: &context)
        }
    }
}
