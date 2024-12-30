import Utils
import ConsoleKit
@main
struct OrzMC {
    static func main() async throws {
        let console = Platform.console
        let input = CommandInput(arguments: CommandLine.arguments)
        var context = CommandContext(console: console, input: input)
        try await console.run(CommandGroup(), with: context)
    }
}
