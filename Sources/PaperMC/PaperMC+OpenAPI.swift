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
    
    static private let client = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
    
    static func testAPI() async throws {
        let response = try await client.latestVersion(.init(path: .init(author: "GeyserMC", slug: "Geyser"), query: .init(channel: "Release")))
        print(response)
    }
}
