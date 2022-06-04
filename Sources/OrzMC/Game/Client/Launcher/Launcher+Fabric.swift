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
        let loading = Platform.console.loadingBar(title: "开始下载Fabric库文件")
        loading.start()
        let downloadItemInfos = libraries.map { lib -> DownloadItemInfo in
            let fileName = lib.downloadURL.lastPathComponent
            let dstFilePath = dstDir.filePath(fileName)
            let dstFileURL = URL(fileURLWithPath: dstFilePath)
            return DownloadItemInfo(sourceURL: lib.downloadURL, dstFileURL: dstFileURL)
        }
        try await Downloader.download(downloadItemInfos)
        loading.succeed()
        Platform.console.output("下载Fabric库文件完成".consoleText(.success))
    }
}
