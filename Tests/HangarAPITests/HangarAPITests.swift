//
//  HangarAPITests.swift
//
//
//  Created by joker on 2023/6/20.
//

import XCTest
@testable import HangarAPI

final class HangarAPITests: XCTestCase {

    let api = HangarAPI()

    func testAuth() async throws {
        let apiKey = "5168d2eb-a40f-425a-a61e-e813b49564fb.0b9ba7a9-2485-4bb5-95ca-698636a79006"
        let token = try await api.authenticate(with: apiKey)
        if let token {
            print(token)
        }
        XCTAssertNotNil(token)
    }

    func testTriggerAPI() async throws {
        let latestVersion = try await api.latestVersion(for: "ViaVersion")
        XCTAssertNotNil(latestVersion)
    }
}
