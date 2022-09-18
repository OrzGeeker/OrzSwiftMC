//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/1/16.
//

import Foundation
import JokerKits

extension Server {

    func launchServer(_ filePath: String, workDirectory: GameDir) async throws {
        
        var args = [
            "-Xms" + serverInfo.minMem,
            "-Xmx" + serverInfo.maxMem,
            "-jar",
            filePath
        ]
        
        if serverInfo.showJarHelpInfo {
            args.append("--help")
        }
        else {
            
            if serverInfo.onlineMode {
                args.append("--online-mode \(serverInfo.onlineMode)")
            }
            
            if serverInfo.forceUpgrade {
                args.append("--forceUpgrade")
            }
            
            if !serverInfo.gui {
                args.append("--nogui")
            }
        }
        
        if serverInfo.debug {
            for arg in args {
                print(arg)
            }
        }
        
        guard await Shell.run(path: try OrzMC.javaPath(), args: args, workDirectory: workDirectory.dirPath)
        else {
            try await launchServer(filePath, workDirectory: workDirectory)
            return
        }
        Platform.console.info("服务端正在运行中...")
        let eulaFilePath = workDirectory.filePath("eula.txt")
        let propertiesFilePath = workDirectory.filePath("server.properties")
        if try modifyEULA(at: eulaFilePath), try modifyProperties(at: propertiesFilePath) {
            guard await Shell.run(path: try OrzMC.javaPath(), args: args, workDirectory: workDirectory.dirPath)
            else {
                Platform.console.output("服务端异常退出", style: .error)
                return
            }
        }
        Platform.console.output("服务端正常退出", style: .success)
    }
}
