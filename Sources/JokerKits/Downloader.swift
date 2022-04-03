//
//  Downloader.swift
//  
//
//  Created by joker on 2022/1/3.
//

import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias DownloadProgress = (_ progress: Double, _ filePath: URL?, _ error: Error?) -> Void

public class Downloader: NSObject {
    
#if canImport(FoundationNetworking)
    @objc dynamic var downloadTask: URLSessionDownloadTask?
    var kvoToken = NSKeyValueObservation?
#else
    var downloadTask: URLSessionDownloadTask?
#endif
    
    var progress: DownloadProgress?
    public func download(_ url: URL, progress: @escaping DownloadProgress) {
        self.progress = progress
        self.downloadTask = URLSession.shared.downloadTask(with: url)
        self.downloadTask?.delegate = self
        self.downloadTask?.resume()
        
        
#if canImport(FoundationNetworking)
        if let downloadTask = self.downloadTask {
            self.addObserver(downloadTask.progress, forKeyPath:#keyPath(Progress.fractionCompleted), options: [.new], context: nil)
        }
#endif
    }

#if canImport(FoundationNetworking)
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(Progress.fractionCompleted), let newFraction = change?[NSKeyValueChangeKey.newKey] {
            print("\(keyPath!) \(newFraction)")
        }
    }
    
    
    deinit {
        self.removeObserver(self, forKeyPath: #keyPath(Progress.fractionCompleted))
    }
#endif
}

extension Downloader: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let progress = self.progress {
            progress(1, location, nil)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let progress = self.progress, totalBytesWritten > 0 {
            progress(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite), nil, nil)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let progress = self.progress {
            progress(Double(task.countOfBytesReceived) / Double(task.countOfBytesExpectedToReceive), nil, error)
        }
    }
}
