//
//  HangarAPIClient.swift
//
//
//  Created by joker on 2023/6/20.
//

import OpenAPIRuntime
import OpenAPIURLSession

/// https://hangar.papermc.io/api-docs#/
public struct HangarAPIClient {

    public init() {}

    private let client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())

    /// 调API前的授权接口
    /// - Parameter apiKey: https://hangar.papermc.io/ 平台帐号申请的apiKey
    /// - Returns: json web token
    public func authenticate(with apiKey: String) async throws -> String? {
        let response = try await client.authenticate(query: .init(apiKey: apiKey))
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let apiSession):
                return apiSession.token
            }
        default:
            return nil
        }
    }

    public func latestVersion(for pluginName: String) async throws -> String? {
        let response = try await client.latestReleaseVersion(.init(path: .init(slug: pluginName), headers: .init(accept: [.init(contentType: .plainText)])))
        switch response {
        case .ok(let output):
            let plainText = try output.body.plainText
            let ret = try await String(collecting: plainText, upTo: 2 * 1024 * 1024)
            return ret
        default:
            return nil
        }
    }
}
