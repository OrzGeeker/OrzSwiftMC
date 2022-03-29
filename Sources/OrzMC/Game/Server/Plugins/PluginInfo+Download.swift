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
    func download(_ console: Console, outputDirURL: URL) async {
        guard let url = URL(string: self.url) else {
            console.error("插件下载地址无效")
            return
        }
        let progressBar = console.progressBar(title: self.name)
        progressBar.start()
        return await withCheckedContinuation { continuation in
            Downloader().download(url) { progress, fileURL, error in
                if let error = error {
                    progressBar.fail()
                    console.error(error.localizedDescription)
                    continuation.resume()
                }
                else if let localFileURL = fileURL {
                    do {
                        let srcFilePath = localFileURL.path
                        let targetFilePath = outputDirURL.appendingPathComponent(self.name).appendingPathExtension("jar").path
                        try FileManager.moveFile(fromFilePath: srcFilePath, toFilePath: targetFilePath, overwrite: true)
                        progressBar.succeed()
                        continuation.resume()
                    }
                    catch let error {
                        progressBar.fail()
                        console.error(error.localizedDescription)
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
