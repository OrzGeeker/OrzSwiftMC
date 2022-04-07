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

struct FabricCommand: Command {
    var help: String = "安装Fabric"
    
    struct Signature: CommandSignature {
        @Flag(name: "server", short: "s", help: "安装服务端Fabric，不指定默认安装客户端Fabric")
        var server: Bool
        
        @Option(name: "installer", short: "i", help: "Fabric安装器文件下载URL链接或者本地文件URL")
        var installer: String?
        
        @Option(name: "version", short: "v", help: "指定游戏版本号")
        var version: String?
    }
    
    func run(using context: CommandContext, signature: Signature) throws {
        if let installer = signature.installer, let version = signature.version, let installerURL = URL(string: installer), version.count > 0 {
            try DispatchGroup().syncExecAndWait {
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
                    let progressbar = context.console.progressBar(title: installerURL.lastPathComponent)
                    progressbar.start()
                    let localFileURL = try await Downloader.download(installerURL) { progress in
                        progressbar.activity.currentProgress = progress
                    }
                    progressbar.succeed()
                    try await Fabric.installFabric(
                        installType,
                        installerFileURL: localFileURL,
                        installDir: installDir.dirPath,
                        version: version)
                }
            } errorClosure: { error in
                context.console.error(error.localizedDescription)
            }
        }
        else {
            var context = context
            outputHelp(using: &context)
        }
    }
}
