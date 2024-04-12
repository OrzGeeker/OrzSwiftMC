//
//  OracleJavaTests.swift
//  
//
//  Created by wangzhizhou on 2022/2/7.
//

import XCTest
@testable import JokerKits
import RegexBuilder

class OracleJavaTests: XCTestCase {

    func testInstalledJVM() throws {
        let jvms = try OracleJava.installedJVM()
        let lines = jvms.split(separator: .newlineSequence)
        XCTAssertFalse(lines.isEmpty)
    }
    
    func testCurrentJVM() throws {
        let jvm = try OracleJava.currentJavaVersion()
        let lines = jvm.split(separator: .newlineSequence)
        XCTAssertFalse(lines.isEmpty)
    }

    func testInstalledJavaVersions() throws {
        if let javas = try OracleJava.installedJavaVersions() {
            XCTAssertFalse(javas.isEmpty)
        }
    }

    func testUninstallAllJavaVersions() throws {
        try OracleJava.uninstallAllJava()
        let javas = try OracleJava.installedJavaVersions()
        XCTAssertNil(javas)
    }
}
