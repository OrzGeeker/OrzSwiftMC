//
//  ShellTests.swift
//  
//
//  Created by joker on 2022/10/9.
//

import XCTest
@testable import JokerKits

final class ShellTests: XCTestCase {

    func testSyncShell() throws {
        let ret = try Shell.runCommand(with: ["which", "bash"])
        XCTAssertEqual(ret, "/bin/bash\n")
    }
    
    func testAsyncShell() async throws {
        let ret = await Shell.runCommand(with: ["which", "bash"])
        XCTAssertEqual(ret, true)
    }
    
    func testCallbackShell() throws {
        let stopGroup = DispatchGroup()
        stopGroup.enter()
        try Shell.runCommand(with: ["which","bash"]) { process in
            XCTAssertEqual(process.terminationStatus, 0)
            stopGroup.leave()
        }
        stopGroup.wait()
    }
}
