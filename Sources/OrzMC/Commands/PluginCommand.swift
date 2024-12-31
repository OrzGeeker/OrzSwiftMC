import ConsoleKit
import JokerKits
import Foundation
import Game

struct PluginCommand: AsyncCommand {
    
    var help: String = Constants.pluginHelp.string
    
    struct Signature: CommandSignature {
        @Flag(name: "list", short: "l", help: Constants.pluginListHelp.string)
        var list: Bool
        
        @Option(name: "output", short: "o", help: Constants.pluginOutputHelp.string)
        var output: String?
    }
    
    func run(using context: CommandContext, signature: Signature) async throws {
        
        let console = context.console
        if signature.list {
            PluginInfo.allPlugins().compactMap {
                try? $0.jsonRepresentation()
            }
            .forEach {
                console.info($0, newLine: true)
            }
        }
        else {
            let outputPath = signature.output ?? Bundle.main.executablePath
            guard let outputFilePath = outputPath else {
                console.error(Constants.uiOutputUnspecifyOutputPath.string)
                return
            }
            let outpuFileDirURL = URL(fileURLWithPath: outputFilePath)
            let progressBar = console.progressBar(title: Constants.uiOutputDownloading.string)
            try await Downloader.download(PluginInfo.downloadItemInfos(of: outpuFileDirURL, console: console), progressBar: progressBar)
            console.output(Constants.uiOutputDownloadedToDir.string.consoleText(.info) + outpuFileDirURL.path.consoleText(.success))
            await Shell.runCommand(with: ["open", outpuFileDirURL.path])
        }
    }
}
