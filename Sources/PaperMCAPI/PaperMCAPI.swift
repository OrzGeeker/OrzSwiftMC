//
//  PaperMCAPI.swift
//
//
//  Created by joker on 2024/1/14.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

/// [PaperMC API](https://api.papermc.io/docs/swagger-ui/index.html?configUrl=/openapi/swagger-config)
/// [openapi.json](https://api.papermc.io/openapi)
public struct PaperMCAPI {

    private let client = Client(
        serverURL: try! Servers.server1(),
        configuration: .init(dateTranscoder: ISO8601DateTranscoder()),
        transport: URLSessionTransport()
    )

    public init() {}
}

public extension PaperMCAPI {

    enum Project: String, CaseIterable {
        case paper
        case travertine
        case waterfall
        case velocity
        case folia

        public var name: String { self.rawValue }
    }

    func allProjects() async throws -> [Project]? {
        let response = try await client.projects()
        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let jsonObj):
                return jsonObj.projects?.compactMap { Project(rawValue: $0) }
            }
        default:
            return nil
        }
    }

    func latestBuild(project: Project, version: String) async throws -> Int32? {

        let response = try await client.version(.init(path: .init(project: project.name, version: version)))

        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let jsonObj):
                let latestBuild = jsonObj.builds?.last
                return latestBuild
            }
        default:
            break
        }
        return nil
    }

    func latestBuildApplication(project: Project, version: String) async throws -> (build: Int32, name: String, sha256: String)? {

        guard let latestBuild = try await latestBuild(project: project, version: version)
        else {
            return nil
        }

        let response = try await client.build(.init(path: .init(project: project.name, version: version, build: latestBuild)))

        switch response {
        case .ok(let output):
            switch output.body {
            case .json(let body):
                guard let application = body.downloads?.additionalProperties["application"],
                      let name = application.name,
                      let sha256 = application.sha256
                else {
                    return nil
                }
                return (latestBuild, name, sha256)
            }
        default:
            return nil
        }
    }

    func downloadLatestBuild(
        project: Project,
        version: String,
        build: Int32,
        name: String) async throws -> (bytes: HTTPBody, totalBytes: Int64)? {

            let response = try await client.download(.init(path: .init(project: project.name,
                                                                       version: version,
                                                                       build: build,
                                                                       download: name)))

            switch response {
            case .ok(let output):
                switch output.body {
                case .json(let jsonObj):
                    print(jsonObj)
                case .application_java_hyphen_archive(let jar):
                    switch jar.length {
                    case .known(let total):
                        return (jar, total)
                    case .unknown:
                        return nil
                    }
                }
            default:
                break
            }
            return nil
        }
}
