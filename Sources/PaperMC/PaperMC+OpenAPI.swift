//
//  File.swift
//  
//
//  Created by joker on 2023/6/20.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

extension PaperMC {
    
    /// https://hangar.papermc.io/api-docs#/
    static private let hangar = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
    
    static func testAPI() async throws {
        let resp = try await hangar.latestReleaseVersion(.init(path: .init(slug: "Geyser")))
        print(resp)
    }
}
