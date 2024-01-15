//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/1/16.
//

import Foundation
import JokerKits

extension Server {
    
    func launchServer(_ filePath: String, workDirectory: GameDir, jarArgs: [String] = []) async throws {
        
        var args = [
            "-server",
            "-Xms" + serverInfo.minMem,
            "-Xmx" + serverInfo.maxMem,
            "-jar",
            filePath,
        ]
                
        if serverInfo.showJarHelpInfo {
            args.append("--help")
        } else {
        
            if serverInfo.forceUpgrade {
                args.append("--forceUpgrade")
            }
            
            if !jarArgs.isEmpty {
                args += jarArgs
            }
            
            if let jarOpts = serverInfo.jarOptions {
                args.append(jarOpts.replacingOccurrences(of: "a:", with: ""))
            }
            
            if !serverInfo.gui {
                args.append("--nogui")
            }
        }
        if serverInfo.debug { print(args.joined(separator: " ")) }
        
        let eulaFilePath = workDirectory.filePath("eula.txt")
        let propertiesFilePath = workDirectory.filePath("server.properties")
        if !FileManager.default.fileExists(atPath: eulaFilePath) || !FileManager.default.fileExists(atPath: propertiesFilePath) {
            await Shell.run(path: try GameUtils.javaPath(), args: args + ["--initSettings"], workDirectory: workDirectory.dirPath)
        }
        try modifyEULA(at: eulaFilePath)
        try modifyProperties(at: propertiesFilePath)
        Platform.console.success("后台服务端启动")
        let process = try Shell.run(path: try GameUtils.javaPath(), args: args, workDirectory: workDirectory.dirPath, terminationHandler: nil)
        print(process.processIdentifier)
    }
}
