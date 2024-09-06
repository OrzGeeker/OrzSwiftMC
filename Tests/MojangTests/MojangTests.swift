//
//  File.swift
//  
//
//  Created by joker on 2021/12/25.
//

import Testing
import Mojang

final class MojangTests {
    @Test
    func gameInfo() async throws {
        
        let manifest = try await Mojang.manifest
        #expect(manifest != nil, "Majong Manifest Info Fetch Failed!")
        
        let gameInfo = try await manifest?.versions.first?.gameInfo
        #expect(gameInfo != nil, "Game Version Info Fetch Failed!")
        
        let assetInfo = try await gameInfo?.assetIndex.assetInfo
        #expect(assetInfo != nil, "Game Asset Info Fetch Failed!")
                
    }
    
    @Test
    func releases() async throws {
        let releases = await Mojang.releases()
        #expect(!releases.isEmpty)
    }
}
