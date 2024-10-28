import ArgumentParser
import Foundation

@available(OSX 10.11, *)
public struct SendKeysCli: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "sendkeys",
        abstract:
            "Command line tool for automating keystrokes and mouse events. More information: https://github.com/socsieng/sendkeys/blob/main/README.md",
        version: "0.0.0", /* auto-updated */
        subcommands: [Sender.self, AppLister.self, MousePosition.self, Transformer.self],
        defaultSubcommand: Sender.self
    )

    public init() {}
}
