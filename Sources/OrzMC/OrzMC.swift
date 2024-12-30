import ConsoleKit

@main
struct OrzMC {
    static func main() async throws {
        let console = Terminal()
        let input = CommandInput(arguments: CommandLine.arguments)
        let context = CommandContext(console: console, input: input)
        try await console.run(CommandGroup(), with: context)
    }
}
