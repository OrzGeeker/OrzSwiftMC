//
//  PaperMCAPITests.swift
//  
//
//  Created by joker on 2024/1/14.
//

import XCTest
@testable import PaperMCAPI

final class PaperMCAPITests: XCTestCase {

    let api = PaperMCAPI()

    let version = "1.19.4"

    func testAllProjects() async throws {
        let projects = try await api.allProjects()
        XCTAssertNotNil(projects)

        if let projects = projects {
            let allProjects = PaperMCAPI.Project.allCases
            XCTAssertTrue(projects == allProjects)
        }
    }

    func testLatestBuild() async throws {

        let latestBuild = try await api.latestBuild(project: .paper, version: version)
        XCTAssertNotNil(latestBuild)
    }
}
 
