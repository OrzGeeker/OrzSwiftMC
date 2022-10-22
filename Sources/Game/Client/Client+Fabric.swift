//
//  File.swift
//  
//
//  Created by joker on 2022/10/22.
//

import Foundation
import Fabric
import JokerKits

extension Client {
    mutating func fabricClientVersionProfileLibrariesDir() throws -> GameDir? {
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
    public mutating func fabricDownloadItems() throws -> [DownloadItemInfo]? {
        guard let dstDir = try self.fabricClientVersionProfileLibrariesDir() else {
            return nil
        }
        guard let libraries = self.clientInfo.fabricModel?.libraries else {
            return nil
        }
        let downloadItemInfos = libraries.map { lib -> DownloadItemInfo in
            let fileName = lib.downloadURL.lastPathComponent
            let dstFilePath = dstDir.filePath(fileName)
            let dstFileURL = URL(fileURLWithPath: dstFilePath)
            return DownloadItemInfo(sourceURL: lib.downloadURL, dstFileURL: dstFileURL)
        }
        return downloadItemInfos
    }
    
}
