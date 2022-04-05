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
        let loadingBar = Platform.console.loadingBar(title: "下载Fabric库文件")
        loadingBar.start()
        for lib in libraries {
            count += 1
            
            let fileName = lib.downloadURL.lastPathComponent
            let dstFilePath = dstDir.filePath(fileName)
            
            loadingBar.activity.title = "下载Fabric库文件 (\(count)/\(total))"
            
            guard !dstFilePath.isExist() else {
                continue
            }
            do {
                let localFileURL = try await Downloader().download(lib.downloadURL, to: dstFilePath)
                try FileManager.moveFile(fromFilePath: localFileURL.path, toFilePath: dstFilePath, overwrite: true)
            } catch let e {
                loadingBar.fail()
                Platform.console.error(e.localizedDescription)
            }
        }
        loadingBar.succeed()
        Platform.console.popEphemeral()
        Platform.console.output("下载Fabric库文件完成".consoleText(.success))
    }
}
