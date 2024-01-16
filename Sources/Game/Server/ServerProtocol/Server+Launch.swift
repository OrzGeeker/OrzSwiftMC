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

            let pidFilePath = workDirectory.filePath("run.pid")
            if FileManager.default.fileExists(atPath: pidFilePath) {
                let pid = try String(contentsOfFile: pidFilePath)
                if await Shell.exist(of: pid), await Shell.kill(with: pid) {
                    Platform.console.success("停止运行中服务端: ", newLine: false)
                    Platform.console.info("PID = \(pid)")
                }
            }
            args.append("--pidFile=\(pidFilePath)")

            if serverInfo.forceUpgrade {
                args.append("--forceUpgrade")
            }

            if serverInfo.demo {
                args.append("--demo")
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
        let process = try Shell.run(path: try GameUtils.javaPath(), args: args, workDirectory: workDirectory.dirPath, terminationHandler: nil)
        Platform.console.success("后台启动服务端: ", newLine: false)
        Platform.console.info("PID = \(process.processIdentifier)")
    }
}
