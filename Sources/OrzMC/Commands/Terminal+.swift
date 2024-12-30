import Utils
import ConsoleKit
import MojangAPI
import Game

extension Terminal {
    public static func userInput(hint: String, completedHint: String? = nil) -> String {
        Platform.console.pushEphemeral()
        Platform.console.output(hint, style: .warning, newLine: false)
        let input = Platform.console.input()
        Platform.console.popEphemeral()
        if let completedHint = completedHint {
            Platform.console.output(completedHint.consoleText(.success) + input.consoleText(.info))
        }
        return input
    }
    public static func chooseFromList<T>(_ list: [T], display: (T) -> ConsoleText, hint: String, completedHint: String) -> T {
        let choose = Platform.console.choose(hint.consoleText(.warning), from: list, display: display)
        Platform.console.output(completedHint.consoleText(.success) + display(choose).description.consoleText(.info))
        return choose
    }
    public static func chooseGameVersion(_ version: String?) async throws -> Version {
        guard let releaseVersions = try? await Mojang.versions(type: .release)
        else {
            throw GameError.noGameVersions
        }
        let versions = Array(releaseVersions[releaseVersions.startIndex..<releaseVersions.startIndex + 10])
        return versions.filter { $0.id == version }.first ?? chooseFromList(versions, display: { $0.id.consoleText() }, hint: Constants.chooseAGameVersion.string, completedHint: Constants.choosedGameVersionHint.string)
    }
}
