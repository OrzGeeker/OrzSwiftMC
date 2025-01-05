import ConsoleKit
import JokerKits
import Foundation
import Game
import HangarAPI

struct PluginCommand: AsyncCommand {
    
    var help: String = Constants.pluginHelp.string
    
    struct Signature: CommandSignature {
        @Flag(name: "list", short: "l", help: Constants.pluginListHelp.string)
        var list: Bool
        
        @Option(name: "output", short: "o", help: Constants.pluginOutputHelp.string)
        var output: String?
        
        @Option(name: "search", short: "s", help: Constants.pluginSearchHelp.string)
        var searchText: String?
        
        @Option(name: "count", short: "c", help: Constants.pluginSearchResultCountHelp.string)
        var searchResultCountMax: Int64?
        
        @Option(name: "version", short: "v", help: Constants.pluginSpecifiedGameVersionHelp.string)
        var version: String?
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        let console = context.console
        let plugin = PaperPlugin()
        if let searchText = signature.searchText {
            let (results, _) = try await plugin.search(
                with: searchText,
                pagination: .init(limit: signature.searchResultCountMax ?? Constants.pluginSearchResultCountMaxDefault)
            )
            guard let results, !results.isEmpty
            else {
                console.error(Constants.uiOutputPluginSearchNoResult.string)
                return
            }
            let searchResultHint = "搜索结果".consoleText(.success) + "(\(results.count))".consoleText(.warning) + "个:\n".consoleText(.success)
            console.output(searchResultHint, newLine: true)
            results.forEach { $0.output(console: console) }
        } else if signature.list {
            let loadingBar = console.loadingBar(title: "插件信息获取中")
            loadingBar.start()
            let foundPlguins = try await plugin.allPlugin()
            loadingBar.activity.title = "插件信息获取完成"
            loadingBar.succeed()
            console.success("获取到的插件如下：")
            foundPlguins.forEach { $0.output(console: console) }
            
            let notFoundPlugins = PaperPlugin.all.filter({ pluginName in
                return !foundPlguins.contains { project in
                    project.name == pluginName
                }
            })
            if !notFoundPlugins.isEmpty {
                console.output("未获取插件信息：".consoleText(.error) + notFoundPlugins.joined(separator: ",").consoleText(.warning) + .newLine)
            }
        }
        else {
            let outputPath = signature.output
            guard let outputDirFilePath = outputPath, outputDirFilePath.isDirPath()
            else {
                console.error(Constants.uiOutputUnspecifyOutputPath.string)
                return
            }
            let outputDirFileURL = URL(fileURLWithPath: outputDirFilePath)
            let progressBar = console.progressBar(title: Constants.uiOutputDownloading.string)
            let allPlugins = try await plugin.allPlugin()
            for plugin in allPlugins {
                guard let downloadItem = try await plugin.downloadItem(outputFileDirURL: outputDirFileURL, version: signature.version),
                      let pluginName = plugin.name
                else {
                    continue
                }
                progressBar.activity.title = "\(pluginName) \(Constants.uiOutputDownloading.string)"
                try await Downloader.download(downloadItem, progressBar: progressBar)
            }
            console.output(Constants.uiOutputDownloadedToDir.string.consoleText(.info) + outputDirFileURL.path.consoleText(.success))
            await Shell.runCommand(with: ["open", outputDirFileURL.path])
        }
    }
}
