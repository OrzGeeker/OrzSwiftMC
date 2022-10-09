//
//  File.swift
//  
//
//  Created by joker on 2022/1/15.
//

import XCTest
@testable import JokerKits
import Dispatch

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class JokerKitsTests: XCTestCase {
    
    func testDirOperations() throws {
        
        let tempDir = NSTemporaryDirectory()
        let testDirPath = NSString.path(withComponents: [
            tempDir,
            "test"
        ])
        
        if testDirPath.isDirPath() {
            try FileManager.default.removeItem(atPath: testDirPath)
        }
        
        let path = NSString.path(withComponents: [
            tempDir,
            "test",
            "dir"
        ])
        try path.makeDirIfNeed()
        XCTAssertTrue(path.isDirPath())
        
        let targetPath = NSString.path(withComponents: [
            tempDir,
            "test",
            "target"
        ])
        
        try FileManager.moveFile(fromFilePath: path, toFilePath: targetPath, overwrite: true)
        XCTAssert(targetPath.isDirPath())
        
        if let dirs = try FileManager.allSubDir(in: testDirPath) {
            XCTAssert(dirs.count == 1)
            XCTAssertEqual(NSString.path(withComponents: [testDirPath, dirs.first!]), targetPath)
        }
        
        let notExistDir = NSString.path(withComponents: [
            tempDir,
            "not",
            "exist"
        ])
        var textFiles = FileManager.allFiles(in: notExistDir, ext: "txt")
        XCTAssertNil(textFiles)
        
        textFiles = FileManager.allFiles(in: testDirPath, ext: "txt")
        XCTAssertNotNil(textFiles)
        if let textFiles = textFiles {
            XCTAssertEqual(textFiles.count, 0)
        }
        
        let testFilePath = NSString.path(withComponents: [
            tempDir,
            "test",
            "testFile.txt"
        ])
        FileManager.default.createFile(atPath: testFilePath, contents: "Just A Test File".data(using: .utf8))
        
        textFiles = FileManager.allFiles(in: testDirPath, ext: "txt")
        XCTAssertNotNil(textFiles)
        if let textFiles = textFiles {
            let index = textFiles.firstIndex(of: testFilePath)
            XCTAssertNotNil(index)
        }
    }
    
    func testCrossPlatformNetwork() async throws {
        let url = URL(string: "https://launchermeta.mojang.com/mc/game/version_manifest.json")!
        
        let (_, _) = try await URLSession.dataTask(from: url)
        
        let request = URLRequest(url: url)
        let (_, _) = try await URLSession.dataTask(for: request)
    }
    
}

