import XCTest
@testable import PaperMC

final class PaperMCTests: XCTestCase {
    
    let jsonDecoder = PaperMC.api.jsonDecoder
    
    let testVersion = "1.19.2"
    
    let testBuild: Int32 = 200
    
    let testVersionFamily = "1.19"
    
    func testProjects() async throws {
        let data = try await PaperMC.api.projects().getData
        XCTAssertNotNil(data)
        
        let projectsResponse = try jsonDecoder.decode(ProjectsResponse.self, from: data!)
        XCTAssertTrue(projectsResponse.projects.count == 4)
    }
    
    func testPaperProject() async throws {
        let data = try await PaperMC.api.projects("paper").getData
        XCTAssertNotNil(data)
        
        let projectResponse = try jsonDecoder.decode(ProjectResponse.self, from: data!)
        XCTAssertTrue(projectResponse.projectId == "paper")
        XCTAssertTrue(projectResponse.projectName == "Paper")
        XCTAssertTrue(!projectResponse.versionGroups.isEmpty)
        XCTAssertTrue(!projectResponse.versions.isEmpty)
    }
    
    func testPaperProjectVersion() async throws {
        let data = try await PaperMC.api.projects("paper").versions(testVersion).getData
        XCTAssertNotNil(data)
        
        let versionResponse = try jsonDecoder.decode(VersionResponse.self, from: data!)
        
        XCTAssertTrue(versionResponse.projectId == "paper")
        XCTAssertTrue(versionResponse.projectName == "Paper")
        XCTAssertTrue(versionResponse.version == testVersion)
        XCTAssertTrue(!versionResponse.builds.isEmpty)
    }
     
    func testPaperProjectVersionBuilds() async throws {
        let data = try await PaperMC.api.projects("paper").versions(testVersion).builds().getData
        XCTAssertNotNil(data)
        
        let buildsResponse = try jsonDecoder.decode(BuildsResponse.self, from: data!)
        
        XCTAssertTrue(buildsResponse.projectId == "paper")
        XCTAssertTrue(buildsResponse.projectName == "Paper")
        XCTAssertTrue(buildsResponse.version == testVersion)
        XCTAssertTrue(!buildsResponse.builds.isEmpty)
    }
    
    func testPaperProjectVersionBuild() async throws {
        let data = try await PaperMC.api.projects("paper").versions(testVersion).builds(testBuild).getData
        XCTAssertNotNil(data)
        
        let buildResponse = try jsonDecoder.decode(BuildResponse.self, from: data!)
        
        XCTAssertTrue(buildResponse.projectId == "paper")
        XCTAssertTrue(buildResponse.projectName == "Paper")
        XCTAssertTrue(buildResponse.version == testVersion)
        XCTAssertTrue(buildResponse.build == testBuild)
        XCTAssertTrue(!buildResponse.changes.isEmpty)
        XCTAssertTrue(!buildResponse.downloads.isEmpty)
    }
    
    func testPaperProjectVersionBuildDownload() async throws {
        let data = try await PaperMC.api.projects("paper").versions(testVersion).builds(testBuild).downloads("paper-\(testVersion)-\(testBuild).jar").getData
        XCTAssertNotNil(data)
        
        let bytes = data!.count
        let sizeMB = bytes / 1024 / 1024
        
        XCTAssertTrue(sizeMB > 30)
        
    }
    
    func testPaperProjectVersionFamily() async throws {
        let data = try await PaperMC.api.projects("paper").versionFamily(testVersionFamily).getData
        XCTAssertNotNil(data)
        
        let versionFamilyResponse = try jsonDecoder.decode(VersionFamilyResponse.self, from: data!)
        
        XCTAssertTrue(versionFamilyResponse.projectId == "paper")
        XCTAssertTrue(versionFamilyResponse.projectName == "Paper")
        XCTAssertTrue(versionFamilyResponse.versionGroup == testVersionFamily)
        XCTAssertTrue(!versionFamilyResponse.versionGroup.isEmpty)
    }
    
    func testPaperProjectVersionFamilyBuilds() async throws {
        let data = try await PaperMC.api.projects("paper").versionFamilyBuilds(testVersionFamily).getData
        XCTAssertNotNil(data)
        
        let versionFamilyBuildsResponse = try jsonDecoder.decode(VersionFamilyBuildsResponse.self, from: data!)
        
        XCTAssertTrue(versionFamilyBuildsResponse.projectId == "paper")
        XCTAssertTrue(versionFamilyBuildsResponse.projectName == "Paper")
        XCTAssertTrue(versionFamilyBuildsResponse.versionGroup == testVersionFamily)
        XCTAssertTrue(!versionFamilyBuildsResponse.versions.isEmpty)
        XCTAssertTrue(!versionFamilyBuildsResponse.builds.isEmpty)
    }
}
