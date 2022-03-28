//
//  PluginInfo.swift
//  
//
//  Created by wangzhizhou on 2022/3/28.
//

import JokerKits
import ConsoleKit
import Foundation

public struct PluginInfo: Codable, JsonRepresentable {
    public let name: String
    public let desc: String
    public let url: String
    public let site: String?
    public let docs: String?
    public let repo: String?
    public func download(_ console: Console, outputDirURL: URL) async {
        guard let url = URL(string: self.url) else {
            console.error("插件下载地址无效")
            return
        }
        let progressBar = console.progressBar(title: self.name)
        progressBar.start()
        return await withCheckedContinuation { continuation in
            Downloader().download(url) { progress, fileURL in
                if let localFileURL = fileURL {
                    progressBar.succeed()
                    do {
                        let srcFilePath = localFileURL.path
                        let targetFilePath = outputDirURL.appendingPathComponent(self.name).appendingPathExtension("jar").path
                        try FileManager.moveFile(fromFilePath: srcFilePath, toFilePath: targetFilePath, overwrite: true)
                        continuation.resume()
                    }
                    catch let e {
                        console.error(e.localizedDescription)
                        continuation.resume()
                    }
                }
                else {
                    progressBar.activity.currentProgress = progress
                }
            }
        }
    }
}

public extension PluginInfo {
    static func getAllPluginInfos() -> [PluginInfo] {
        return [
            PluginInfo(
                name: "Grief Prevention",
                desc: "防止服务器悲剧发生",
                url:  "https://dev.bukkit.org/projects/grief-prevention/files/latest",
                site: "https://dev.bukkit.org/projects/grief-prevention",
                docs: "https://docs.griefprevention.com/",
                repo: "https://github.com/TechFortress/GriefPrevention"),
        ]
    }
}
