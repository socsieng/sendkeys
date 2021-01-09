import ArgumentParser
import Foundation

@available(OSX 10.11, *)
public struct SendKeysCli: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "sendkeys",
        abstract: "Command line tool for automating keystrokes and mouse events.",
        version: "0.0.0", /* auto-updated */
        subcommands: [Sender.self, MousePosition.self, Transformer.self],
        defaultSubcommand: Sender.self
    )

    public init() {}
}
