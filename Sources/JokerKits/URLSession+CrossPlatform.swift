//
//  File.swift
//  
//
//  Created by joker on 2022/3/21.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// 同时支持在MacOS和Linux上调用
public extension URLSession {
    static func dataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
#if canImport(FoundationNetworking)
        return await withCheckedContinuation({ continuation in
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    fatalError()
                }
                continuation.resume(returning: (data, response))
            }.resume()
        })
#else
        return try await URLSession.shared.data(for: request)
#endif
    }
    static func dataTask(from url: URL) async throws -> (Data, URLResponse) {
        let request = URLRequest(url: url)
        return try await URLSession.dataTask(for: request)
    }
}
