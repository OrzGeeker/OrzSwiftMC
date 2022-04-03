//
//  Downloader.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Foundation
import Alamofire

public typealias DownloadProgress = (_ progress: Double, _ filePath: URL?, _ error: Error?) -> Void
public class Downloader: NSObject {
    var downloadTask: URLSessionDownloadTask?
    var progress: Double = 0
    public func download(_ url: URL, progress: @escaping DownloadProgress) {
        AF.download(url).downloadProgress(closure: { downloadProgress in
            self.progress = downloadProgress.fractionCompleted
            progress(self.progress, nil, nil)
        }).response { response in
            guard response.error != nil else {
                progress(self.progress, nil, response.error)
                return
            }
            if let fileURL = response.fileURL {
                progress(1, fileURL, nil)
            }
            else {
                let error = AFError.responseSerializationFailed(reason: .invalidEmptyResponse(type: "找不到已下载的文件"))
                progress(self.progress, nil, error)
            }
        }
    }
}
