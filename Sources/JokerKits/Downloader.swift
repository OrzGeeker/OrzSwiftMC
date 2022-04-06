//
//  Downloader.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Foundation
import Alamofire

public typealias UpdateProgress = (_ progress: Double) -> Void
/// 使用[Alamofire](https://github.com/Alamofire/Alamofire)下载大文件
/// 参考文章: <https://serveanswer.com/questions/alamofire-downloadprogress-completion-handler-to-async-await>
public struct Downloader {
    public static func download(_ url: URL, updateProgress: @escaping UpdateProgress) async throws -> URL {
        let downloadRequest = AF.download(url)
        Task {
            for await progress in downloadRequest.downloadProgress() {
                updateProgress(progress.fractionCompleted)
            }
        }
        return try await downloadRequest.serializingDownloadedFileURL().value
    }
}
