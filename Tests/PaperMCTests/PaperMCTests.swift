import XCTest
@testable import PaperMC

final class PaperMCTests: XCTestCase {
    
    let jsonDecoder = PaperMC.api.jsonDecoder
    
    func testProjects() async throws {
        let data = try await PaperMC.api.projects().getData
        XCTAssertNotNil(data)
        
        let projectsResponse = try jsonDecoder.decode(ProjectsResponse.self, from: data!)
        XCTAssert(projectsResponse.projects.count == 4)
    }
    
    func testPaperProject() async throws {
        let data = try await PaperMC.api.projects("paper").getData
        XCTAssertNotNil(data)
        
        let projectResponse = try jsonDecoder.decode(ProjectResponse.self, from: data!)
        XCTAssert(projectResponse.projectId == "paper")
        XCTAssert(projectResponse.projectName == "Paper")
        XCTAssert(!projectResponse.versionGroups.isEmpty)
        XCTAssert(!projectResponse.versions.isEmpty)
    }
    
    func testPaperProjectVersion() async throws {
        let version = "1.19.2"
        let data = try await PaperMC.api.projects("paper").versions(version).getData
        XCTAssertNotNil(data)
        
        let buildsResponse = try jsonDecoder.decode(BuildsResponse.self, from: data!)
        
        XCTAssert(buildsResponse.projectId == "paper")
        XCTAssert(buildsResponse.projectName == "Paper")
        XCTAssert(buildsResponse.version == version)
        XCTAssert(!buildsResponse.builds.isEmpty)
    }
     
    func testPaperProjectVersionBuilds() async throws {
        
    }
    
    func testPaperProjectVersionBuild() async throws {
        
    }
    
    func testPaperProjectVersionBuildDownload() async throws {
        
    }
    
    func testPaperProjectVersionFamily() async throws {
        
    }
    
    func testPaperProjectVersionFamilyBuilds() async throws {
        
    }
    
    func testPaper() async throws {
        let paperAPI = PaperMC.api.projects("paper")
        let data = try await paperAPI.getData
        XCTAssertNotNil(data)
        if let data = data {
            let paper = try jsonDecoder.decode(ProjectResponse.self, from: data)
            XCTAssertNotNil(paper)
            XCTAssert(paper.versions.count > 0)
            let paperVersionAPI = paperAPI.versions(paper.versions.last)
            let data = try await paperVersionAPI.getData
            XCTAssertNotNil(data)
            if let data = data {
                let paperVersion = try jsonDecoder.decode(BuildsResponse.self, from: data)
                XCTAssertNotNil(paperVersion)
                XCTAssert(paperVersion.builds.count > 0)
                
                let paperVersionBuildAPI = paperVersionAPI.builds("\(paperVersion.builds.last!)")
                let data = try await paperVersionBuildAPI.getData
                XCTAssertNotNil(data)
                if let data = data {
                    let build = try jsonDecoder.decode(BuildResponse.self, from: data)
                    XCTAssertNotNil(build)
                    XCTAssert(build.downloads.count > 0)
                    
                    if let name = build.downloads.values.first?.name {
                        let paperVersionBuildDownloadAPI = paperVersionBuildAPI.downloads(name)
                        let data = try await paperVersionBuildDownloadAPI.getData
                        XCTAssertNotNil(data)
                    }
                }
            }
            
            let paperVersionFamilyAPI = paperAPI.versionFamily("1.18")
            let familyData = try await paperVersionFamilyAPI.getData
            XCTAssertNotNil(familyData)
            if let familyData = familyData {
                let versionFamily = try jsonDecoder.decode(VersionFamilyResponse.self, from: familyData)
                XCTAssertNotNil(versionFamily)
                XCTAssert(versionFamily.versions.count > 0)
            }
            
            let paperVersionFamilyBuildsAPI = paperAPI.versionFamilyBuilds("1.18")
            let familyBuildsData = try await paperVersionFamilyBuildsAPI.getData
            XCTAssertNotNil(familyBuildsData)
            if let familyBuildsData = familyBuildsData {
                let versionFamilyBuilds = try jsonDecoder.decode(VersionFamilyBuildsResponse.self, from: familyBuildsData)
                XCTAssertNotNil(versionFamilyBuilds)
                XCTAssert(versionFamilyBuilds.builds.count > 0)
            }
        }
    }
}
