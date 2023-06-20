//
//  PaperMCAPITests.swift
//  
//
//  Created by joker on 2023/6/20.
//

import XCTest
@testable import PaperMC

final class PaperMCAPITests: XCTestCase {
    
    func testOpenAPI() async throws {
        try await PaperMC.testAPI()
    }
}
