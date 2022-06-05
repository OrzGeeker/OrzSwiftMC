//
//  Downloader.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Foundation
import Alamofire
import ConsoleKit

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

public struct Downloader {
    
    public static func download(_ sourceURL: URL) -> (DownloadTask<URL>, StreamOf<Progress>) {
        let request = AF.download(sourceURL)
        return (request.serializingDownloadedFileURL(), request.downloadProgress())
    }
    
    public static func download(_ item: DownloadItemInfo, progressBar: ActivityIndicator<ProgressBar>? = nil) async throws {
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
        let (downloadURLTask, downloadProgressStream) = Downloader.download(item.sourceURL)
        if let progressBar = progressBar {
            progressBar.start(refreshRate: 100)
            for try await progress in downloadProgressStream {
                try progressBar.updateProgress(progress.fractionCompleted)
            }
            progressBar.succeed()
        }
        try FileManager.moveFile(fromFilePath: try await downloadURLTask.value.path, toFilePath: item.dstFileURL.path, overwrite: true)
    }
    
    public static func download(_ items: [DownloadItemInfo], progressBar: ActivityIndicator<ProgressBar>? = nil) async throws {
        try await withThrowingTaskGroup(of: Void.self, body: { group in
            for item in items {
                group.addTask {
                    try await Downloader.download(item)
                }
            }
            if let progressBar = progressBar {
                let total = items.count
                var index = 0
                progressBar.start(refreshRate: 100)
                for try await _ in group {
                    index += 1
                    let progress = Double(index) / Double(total)
                    try progressBar.updateProgress(progress)
                }
                progressBar.succeed()
            } else {
                try await group.waitForAll()
            }
        })
    }
}

extension ActivityIndicator where A == ProgressBar {
    func updateProgress(_ progress: Double) throws {
        self.activity.currentProgress = progress
        let progressDesc = String(format: "%d%%", arguments: [Int(self.activity.currentProgress * 100)])
        var title = self.activity.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let range = NSRange(location: 0, length: title.count)
        let regex = try NSRegularExpression(pattern: "\\d+%$")
        if let _ = regex.firstMatch(in: title, range: range) {
            title = regex.stringByReplacingMatches(in: title, range: range, withTemplate: progressDesc)
        } else {
            title.append(" ")
            title.append(progressDesc)
        }
        self.activity.title = title
    }
}
