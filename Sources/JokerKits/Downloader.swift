//
//  Downloader.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Foundation
import Alamofire

public struct DownloadItemInfo {
    
    public let sourceURL: URL
    public let dstFileURL: URL
    
    public let hash: String?
    public let hashType: HashType?
    
    public init(sourceURL: URL, dstFileURL: URL, hash: String? = nil, hashType: HashType? = nil) {
        self.sourceURL = sourceURL
        self.dstFileURL = dstFileURL
        self.hash = hash
        self.hashType = hashType
    }
    
    public enum HashType {
        case sha1
        case sha256
    }
}

public typealias UpdateProgress = (_ progress: Double) -> Void

public struct Downloader {
    
    /// 使用[Alamofire](https://github.com/Alamofire/Alamofire)下载大文件
    /// 参考文章: <https://serveanswer.com/questions/alamofire-downloadprogress-completion-handler-to-async-await>
    public static func download(_ url: URL, updateProgress: @escaping UpdateProgress) async throws -> URL {
        let downloadRequest = AF.download(url)
        Task {
            for await progress in downloadRequest.downloadProgress() {
                updateProgress(progress.fractionCompleted)
            }
        }
        return try await downloadRequest.serializingDownloadedFileURL().value
    }
    
    public static func download(_ items: [DownloadItemInfo], updateProgress: @escaping UpdateProgress) async throws {
        try await withThrowingTaskGroup(of: Void.self, body: { group in
            for item in items {
                group.addTask {
                    if let hash = item.hash, let hashType = item.hashType, item.dstFileURL.path.isExist() {
                        var hashValue: String? = nil
                        switch hashType {
                        case .sha1:
                            hashValue = try item.dstFileURL.fileSHA1Value
                        case .sha256:
                            hashValue = try item.dstFileURL.fileSHA256Value
                        }
                        guard hashValue != hash else {
                            return
                        }
                    }
                    let tempFileURL = try await AF.download(item.sourceURL).serializingDownloadedFileURL().value
                    try FileManager.moveFile(fromFilePath: tempFileURL.path, toFilePath: item.dstFileURL.path, overwrite: true)
                }
            }
            var count = 0
            let total = items.count
            for try await _ in group {
                count += 1
                let progress = Double(count) / Double(total)
                updateProgress(progress)
            }
        })
    }
}
