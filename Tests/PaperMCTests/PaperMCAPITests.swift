//
//  PaperMCAPITests.swift
//
//
//  Created by joker on 2023/6/20.
//

import XCTest
@testable import PaperMC
@testable import HangarAPI

final class PaperMCAPITests: XCTestCase {

    func testAuth() async throws {
        let apiKey = "5168d2eb-a40f-425a-a61e-e813b49564fb.0b9ba7a9-2485-4bb5-95ca-698636a79006"
        let token = try await PaperMC.hanger.authenticate(with: apiKey)
        if let token {
            print(token)
        }
        XCTAssertNotNil(token)
    }

    func testTriggerAPI() async throws {
        let latestVersion = try await PaperMC.hanger.latestVersion(for: "ViaVersion")
        XCTAssertNotNil(latestVersion)
    }
}
