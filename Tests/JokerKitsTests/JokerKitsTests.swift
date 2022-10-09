//
//  File.swift
//  
//
//  Created by joker on 2022/1/15.
//

import XCTest
@testable import JokerKits

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class JokerKitsTests: XCTestCase {
    
    func testCrossPlatformNetwork() async throws {
        let url = URL(string: "https://launchermeta.mojang.com/mc/game/version_manifest.json")!
        
        let (_, _) = try await URLSession.dataTask(from: url)
        
        let request = URLRequest(url: url)
        let (_, _) = try await URLSession.dataTask(for: request)
    }
    
}

