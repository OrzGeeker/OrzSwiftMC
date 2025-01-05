import HangarAPI
import Foundation
import ConsoleKit

public struct PaperPlugin {
    
    public init() {}
    
    private let platform = PluginPlatform.PAPER
    
    public func search(
        with text: String,
        pagination: PluginSearchPagination = .init(limit: 5, offset: 0)
    ) async throws -> ([PluginProject]?, PluginPagination?) {
        return try await HangarAPIClient().searchPlugin(
            text: text,
            platform: platform,
            pagination: pagination
        )
    }
    
    public func latesetVersionDownload(of project: PluginProject, version: String? = nil) async throws -> PluginPlatformVersionDownload? {
        let platformName = platform.rawValue
        guard let name = project.name,
              let latestVersion = try await HangarAPIClient().versions(for: name)?.first
        else {
            return nil
        }
        if let version,
           let platformDependencies = latestVersion.platformDependencies?.additionalProperties[platformName],
           !platformDependencies.contains(version) {
            return nil
        }
        let platformVersionDownload = latestVersion.downloads?.additionalProperties[platformName]
        return platformVersionDownload
    }
}

public extension PaperPlugin {
    
    static let all = [
        "GetMeHome",
        "Geyser",
        "GriefPreventtion",
        "LoginSecurity",
        "LuckPerms",
        "SkinsRestorer",
        "Vault",
        "ViaBackwards",
        "ViaVersion",
        "WorldEdit",
        "WorldGuard",
        "Essentials",
        "DeathChest"
    ]
    
    func allPlugin () async throws -> [PluginProject] {
        var ret = [PluginProject]()
        for pluginName in PaperPlugin.all {
            guard let project = try await search(with: pluginName, pagination: .init(limit: 1)).0?.filter ({
                $0.name == pluginName
            }).first
            else {
                continue
            }
            ret.append(project)
        }
        return ret
    }
}

public extension PluginProject {
    func output(console: any Console) {
        let dateFormatStyle = Date.ISO8601FormatStyle.init(
            dateSeparator: .dash, dateTimeSeparator: .space,
            timeSeparator: .colon, timeZoneSeparator: .colon,
            timeZone: .current
        )
        guard let name = name, let desc = description,
              let category = category?.rawValue,
              let createdAt = createdAt?.ISO8601Format(dateFormatStyle),
              let lastUpdateAt = lastUpdated?.ISO8601Format(dateFormatStyle),
              let downloads = stats?.downloads,
              let views = stats?.views,
              let stars = stats?.stars
        else {
            return
        }
        let title = name.consoleText(color: .green, isBold: true) + " - " + desc.consoleText(.plain)
        let downloadCount = "downloads: " + "\(downloads)".consoleText(.warning)
        let viewCount = "views: " + "\(views)".consoleText(.warning)
        let starCount = "stars: " + "\(stars)".consoleText(.warning)
        let leadingTab: ConsoleText = "  "
        let stats = downloadCount + " " + viewCount + " " + starCount
        let createdDate = "Created: " + createdAt.consoleText(.error)
        let updatedDate = "Updated: " + lastUpdateAt.consoleText(.error)
        let categoryName = "Category: " + category.consoleText(.warning)
        console.output(title)
        [updatedDate, createdDate, stats, categoryName].forEach {
            console.output(leadingTab + $0)
        }
        console.output(.newLine, newLine: false)
    }
}

import JokerKits
public extension PluginProject {
    func downloadItem(outputFileDirURL: URL, version: String?) async throws -> DownloadItemInfo? {
        let latestPlatformVersionDownload = try await PaperPlugin().latesetVersionDownload(of: self, version: version)
        guard let downloadURL = latestPlatformVersionDownload?.downloadURL,
              let pluginName = self.name
        else {
            return nil
        }
        let outputFileName = pluginName + ".jar"
        let outputFileURL = outputFileDirURL.appending(path: outputFileName)
        return DownloadItemInfo(sourceURL: downloadURL, dstFileURL: outputFileURL)
    }
}
