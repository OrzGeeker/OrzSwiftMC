//
//  OrzMC.swift
//  
//
//  Created by wangzhizhou on 2021/12/24.
//

import JokerKits
import ConsoleKit
import Foundation

#if swift(>=5.5) && canImport(_Concurrency)
@main
struct OrzMC {
    static func main() async throws {
        let console = Platform.console
        let input = CommandInput(arguments: CommandLine.arguments)
        let context = CommandContext(console: console, input: input)
        do {
            try await console.run(OrzCommandGroup(), with: context)
        }
        catch let error {
            console.error("\(error)")
            exit(1)
        }
    }
}
#endif
