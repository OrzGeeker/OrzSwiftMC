//
//  File.swift
//
//
//  Created by joker on 2022/9/18.
//

import JokerKits
import Utils

extension Server {
    
    func modifyEULA(at filePath: String) throws -> Bool {
        let disagreeEULA = "eula=false"
        guard let eulaFileContent = try? String(contentsOfFile: filePath), eulaFileContent.contains(disagreeEULA)
        else {
            return false
        }
        let agreeEULA = "eula=true"
        try eulaFileContent.replacingOccurrences(of: disagreeEULA, with: agreeEULA)
            .write(toFile: filePath, atomically: false, encoding: .utf8)
        return true
    }
    
    func modifyProperties(at filePath: String) throws -> Bool {
        let onlineModeContent = "online-mode=true"
        guard let propertiesFileConent = try? String(contentsOfFile: filePath), propertiesFileConent.contains(onlineModeContent)
        else {
            return false
        }
        let offlineModeContent = "online-mode=false"
        try propertiesFileConent.replacingOccurrences(of: onlineModeContent, with: offlineModeContent)
            .write(toFile: filePath, atomically: false, encoding: .utf8)
        return true
    }
}
