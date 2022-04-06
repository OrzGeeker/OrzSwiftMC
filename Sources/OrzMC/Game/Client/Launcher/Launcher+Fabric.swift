//
//  File.swift
//  
//
//  Created by joker on 2022/4/5.
//

import Foundation
import JokerKits
import Fabric

extension Launcher {
    func fabricClientVersionProfileLibrariesDir() throws -> GameDir? {
        guard let launcherProfile = self.clientInfo.launcherProfile, launcherProfile.selectedProfile.contains("fabric"), let lastVersionId = launcherProfile.profiles[launcherProfile.selectedProfile]?.lastVersionId else {
            return nil
        }
        let fabricLaunchProfileDir = GameDir.clientVersionProfile(version: self.clientInfo.version.id, profile: lastVersionId)
        let fabricLaunchProfilePath = fabricLaunchProfileDir.filePath("\(lastVersionId).json")
        let fabricLaunchProfileURL = URL(fileURLWithPath: fabricLaunchProfilePath)
        self.clientInfo.fabricModel = try Fabric.launcherConfig(fabricLaunchProfileURL)
        
        return GameDir.clientVersionProfileLibraries(version: self.clientInfo.version.id, profile: lastVersionId)
    }
    func fabricClientJVMOptions() -> [String]? {
        return self.clientInfo.fabricModel?.arguments.jvm
    }
    func fabricClientMainClass() -> String? {
        return self.clientInfo.fabricModel?.mainClass
    }
    func downloadFabric() async throws {
        guard let dstDir = try self.fabricClientVersionProfileLibrariesDir() else {
            return
        }
        guard let libraries = self.clientInfo.fabricModel?.libraries else {
            return
        }
        var count = 0
        let total = libraries.count
        Platform.console.pushEphemeral()
        Platform.console.output("开始下载Fabric库文件".consoleText(.info))
        for lib in libraries {
            count += 1
            
            let fileName = lib.downloadURL.lastPathComponent
            let dstFilePath = dstDir.filePath(fileName)
            
            let progressBar = Platform.console.progressBar(title: "(\(count)/\(total)) \(fileName)")
            progressBar.start()
            
            guard !dstFilePath.isExist() else {
                progressBar.succeed()
                continue
            }
            
            do {
                let localFileURL = try await Downloader.download(lib.downloadURL, updateProgress: { progress in
                    progressBar.activity.currentProgress = progress
                })
                progressBar.succeed()
                try FileManager.moveFile(fromFilePath: localFileURL.path, toFilePath: dstFilePath, overwrite: true)
            } catch let e {
                progressBar.fail()
                Platform.console.error(e.localizedDescription)
            }
        }
        Platform.console.popEphemeral()
        Platform.console.output("下载Fabric库文件完成".consoleText(.success))
    }
}
