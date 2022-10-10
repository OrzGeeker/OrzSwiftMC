//
//  File.swift
//  
//
//  Created by wangzhizhou on 2021/12/25.
//

import Foundation
import JokerKits

/// [PaperMC](https://papermc.io/)
public struct PaperMC {
    
    public static var api = API()
    
    /// [PaperMC API v2](https://papermc.io/api/docs/swagger-ui/index.html?configUrl=/api/openapi/swagger-config)
    public struct API {
        
        public lazy var jsonDecoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }()
        
        var pathComponents = [String]()
        
        public init(_ pathComponents: [String] = ["https://papermc.io/api", "v2"]) {
            self.pathComponents = pathComponents
        }
        
        public func projects(_ project: String? = nil) -> API {
            var ret = API(self.pathComponents)
            ret.pathComponents.append("projects")
            if let project = project {
                ret.pathComponents.append(project)
            }
            return ret
        }
        
        public func versions(_ version: String? = nil) -> API {
            var ret = API(self.pathComponents)
            ret.pathComponents.append("versions")
            if let version = version {
                ret.pathComponents.append(version)
            }
            return ret
        }
        
        public func builds(_ build: String? = nil) -> API {
            var ret = API(self.pathComponents)
            ret.pathComponents.append("builds")
            if let build = build {
                ret.pathComponents.append(build)
            }
            return ret
        }
        
        public func downloads(_ download: String? = nil) -> API {
            var ret = API(self.pathComponents)
            ret.pathComponents.append("downloads")
            if let download = download {
                ret.pathComponents.append(download)
            }
            return ret
        }
        
        public func versionFamily(_ family: String) -> API {
            var ret = API(self.pathComponents)
            ret.pathComponents.append("version_group")
            ret.pathComponents.append(family)
            assert(family.count > 0, "family must not be empty")
            return ret
        }
        
        public func versionFamilyBuilds(_ family: String) -> API {
            var ret = API(self.pathComponents)
            ret.pathComponents.append("version_group")
            ret.pathComponents.append(family)
            assert(family.count > 0, "family must not be empty")
            ret.pathComponents.append("builds")
            return ret
        }
        
        public var getData: Data? {
            get async throws {
                guard let data = try await self.url?.getData
                else {
                    return nil
                }
                return data
            }
        }
        
        public var url: URL? {
            let url = String(NSString.path(withComponents: self.pathComponents))
            return URL(string: url)
        }
    }
}
