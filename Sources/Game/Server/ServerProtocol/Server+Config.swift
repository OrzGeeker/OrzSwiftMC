//
//  File.swift
//  
//
//  Created by joker on 2022/9/18.
//

import JokerKits
import Utils

extension Server {
    
    @discardableResult
    func modifyEULA(at filePath: String) throws -> Bool {
        let disagreeEULA = "eula=false"
        guard let eulaFileContent = try? String(contentsOfFile: filePath), eulaFileContent.contains(disagreeEULA)
        else {
            return false
        }
        
        // 修改ELUA协议
        Platform.console.pushEphemeral()
        Platform.console.warning("首次启动，未同意EULA协议")
        let agreeEULA = "eula=true"
        try eulaFileContent.replacingOccurrences(of: disagreeEULA, with: agreeEULA)
            .write(toFile: filePath, atomically: false, encoding: .utf8)
        Platform.console.popEphemeral()
        Platform.console.success("已同意EULA协议")
        
        return true
    }
    
    @discardableResult
    func modifyProperties(at filePath: String) throws -> Bool {
        let onlineModeContent = "online-mode=true"
        guard let propertiesFileConent = try? String(contentsOfFile: filePath), propertiesFileConent.contains(onlineModeContent)
        else {
            return false
        }
        
        // 修改服务器属性
        Platform.console.pushEphemeral()
        let offlineModeContent = "online-mode=false"
        try propertiesFileConent.replacingOccurrences(of: onlineModeContent, with: offlineModeContent)
            .write(toFile: filePath, atomically: false, encoding: .utf8)
        Platform.console.popEphemeral()
        Platform.console.success("服务器运行为离线模式")
        
        return true
    }
}
