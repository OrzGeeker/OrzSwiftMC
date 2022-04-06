//
//  PluginInfo+Download.swift
//  
//
//  Created by wangzhizhou on 2022/3/29.
//

import Foundation
import JokerKits
import ConsoleKit

extension PluginInfo {
    func download(_ console: Console, outputDirURL: URL) async throws {
        guard let url = URL(string: self.url) else {
            console.error("插件下载地址无效")
            return
        }
        let progressBar = console.progressBar(title: self.name)
        progressBar.start()
        let localFileURL = try await Downloader.download(url, updateProgress: { progress in
            progressBar.activity.currentProgress = progress
        })
        let srcFilePath = localFileURL.path
        let targetFilePath = outputDirURL.appendingPathComponent(self.name).appendingPathExtension("jar").path
        try FileManager.moveFile(fromFilePath: srcFilePath, toFilePath: targetFilePath, overwrite: true)
        progressBar.succeed()
    }
}
