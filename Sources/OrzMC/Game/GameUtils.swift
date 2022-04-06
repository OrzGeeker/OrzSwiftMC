//
//  File.swift
//  
//
//  Created by wangzhizhou on 2022/1/13.
//

import Foundation
import ConsoleKit
import JokerKits

struct GameUtils {
    enum HashType {
        case sha1
        case sha256
    }
    /// 下载文件
    /// - Parameters:
    ///   - url: 文件URL
    ///   - progressHint: 下载进度提示文字
    ///   - targetDir: 下载后放入的目录
    ///   - hash: 文件的哈希值
    ///   - hashType: 计算哈希值的方法
    ///   - filename: 下载后的转存文件名
    ///   - console: 控制台实例
    static func download(
        _ url: URL,
        progressHint: String?,
        targetDir: GameDir,
        hash: String,
        hashType: HashType = .sha1,
        filename: String? = nil,
        console: Console = Platform.console
    ) async throws {
        var progressBar: ActivityIndicator<ProgressBar>? = nil
        let showProgress = progressHint != nil
        if showProgress {
            progressBar = console.progressBar(title: progressHint!)
        }
        let toFilePath = targetDir.filePath(filename ?? url.lastPathComponent)
        let toFilePathURL = URL(fileURLWithPath: toFilePath)
        if toFilePath.isExist() {
            var hashValue = try toFilePathURL.fileSHA1Value
            switch hashType {
            case .sha1:
                hashValue = try toFilePathURL.fileSHA1Value
            case .sha256:
                hashValue = try toFilePathURL.fileSHA256Value
            }
            guard hashValue != hash else {
                progressBar?.start()
                progressBar?.succeed()
                return
            }
        }
        progressBar?.start()
        let fileURL = try await Downloader.download(url) { progress in
            progressBar?.activity.currentProgress = progress
        }
        // Check Hash Value
        var hashValue = try fileURL.fileSHA1Value
        switch hashType {
        case .sha1:
            hashValue = try fileURL.fileSHA1Value
        case .sha256:
            hashValue = try fileURL.fileSHA256Value
        }
        guard hashValue == hash else {
            progressBar?.fail()
            throw URLError(.badServerResponse)
        }
        // 移动文件
        let fromFilePath = fileURL.path
        try FileManager.moveFile(fromFilePath: fromFilePath, toFilePath: toFilePath, overwrite: true)
        progressBar?.succeed()
    }
}
