//
//  PaperMCAPITests.swift
//  
//
//  Created by joker on 2024/1/14.
//

import XCTest
@testable import PaperMCAPI

final class PaperMCAPITests: XCTestCase {

    let client = PaperMCAPIClient()

    let version = "1.19.4"

    func testAllProjects() async throws {
        let projects = try await client.allProjects()
        XCTAssertNotNil(projects)

        if let projects = projects {
            let allProjects = PaperMCAPIClient.Project.allCases
            XCTAssertTrue(projects == allProjects)
        }
    }

    func testLatestBuild() async throws {

        let latestBuild = try await client.latestBuild(project: .paper, version: version)
        XCTAssertNotNil(latestBuild)
    }
}
 
