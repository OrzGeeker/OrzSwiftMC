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

public struct Downloader {
        
    public static func download(_ sourceURL: URL) async throws -> URL {
        return try await AF.download(sourceURL).serializingDownloadedFileURL().value
    }
    
    public static func download(_ item: DownloadItemInfo) async throws {
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
        let tempFileURL = try await Downloader.download(item.sourceURL)
        try FileManager.moveFile(fromFilePath: tempFileURL.path, toFilePath: item.dstFileURL.path, overwrite: true)
    }
    
    public static func download(_ items: [DownloadItemInfo]) async throws {
        try await withThrowingTaskGroup(of: Void.self, body: { group in
            for item in items {
                group.addTask {
                    try await Downloader.download(item)
                }
            }
            for try await _ in group {
                
            }
        })
    }
}
