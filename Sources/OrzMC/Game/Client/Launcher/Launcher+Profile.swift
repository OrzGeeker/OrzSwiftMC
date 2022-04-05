//
//  File.swift
//  
//
//  Created by joker on 2022/4/4.
//

import Foundation
import JokerKits

extension Launcher {
    func chooseProfile() throws  {
        let version = self.clientInfo.version.id
        let clientDir = GameDir.client(version: version)
        let dstFilePath = clientDir.filePath("launcher_profiles.json")
        if dstFilePath.isExist() {
            let fileURL = URL(fileURLWithPath: dstFilePath)
            let data = try Data(contentsOf: fileURL)
            var launcherProfile = try LauncherProfile.profile(from: data)
            let menuItems = Array(launcherProfile.profiles.keys.sorted())
            let chooseItem = Platform.console.choose("选择启动方式：".consoleText(.success), from: menuItems)
            Platform.console.output("启动：".consoleText(.success), newLine: false)
            Platform.console.output(chooseItem.consoleText(.info))
            launcherProfile.selectedProfile = chooseItem
            self.clientInfo.launcherProfile = launcherProfile
        }
        // 保存最新的Launcher Profile
        try clientDir.dirPath.makeDirIfNeed()
        guard let launcherProfile = self.clientInfo.launcherProfile else {
            try LauncherProfile.vanillaProfile(version: version).writeToFile(dstFilePath)
            return
        }
        try launcherProfile.writeToFile(dstFilePath)
    }
}
