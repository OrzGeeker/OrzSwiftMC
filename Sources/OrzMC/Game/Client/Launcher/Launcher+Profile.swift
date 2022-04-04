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
            // TODO: 展示选择项目
            Platform.console.output("选项启动方式")
        }
        else {
            try clientDir.dirPath.makeDirIfNeed()
            try LauncherProfile.vanillaProfile(version: version).writeToFile(dstFilePath)
        }
    }
}
