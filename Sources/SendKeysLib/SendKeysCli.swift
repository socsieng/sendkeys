import ArgumentParser
import Foundation

@available(OSX 10.11, *)
public struct SendKeysCli: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "sendkeys",
        abstract: "Command line tool for automating keystrokes and mouse events",
        version: "0.0.0", /* auto-updated */
        subcommands: [MousePosition.self]
    )

    @Option(name: .shortAndLong, help: "Name of a running application to send keys to.")
    var applicationName: String?

    @Option(name: .shortAndLong, help: "Default delay between keystrokes in seconds.")
    var delay: Double = 0.1

    @Option(name: .shortAndLong, help: "Initial delay before sending commands in seconds.")
    var initialDelay: Double = 1

    @Option(name: NameSpecification([.customShort("f"), .long ]), help: "File containing keystroke instructions.")
    var inputFile: String?

    @Option(name: .shortAndLong, help: "String of characters to send.")
    var characters: String?

    public init() { }

    public mutating func run() throws {
        let accessEnabled = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)

        if !accessEnabled {
            fputs("WARNING: Accessibility preferences must be enabled to use this tool. If running from the terminal, make sure that your terminal app has accessibility permissiions enabled.\n\n", stderr)
        }

        let commandProcessor = CommandsProcessor(defaultPause: delay)
        var commandString: String?

        if !(inputFile ?? "").isEmpty {
            if let data = FileManager.default.contents(atPath: inputFile!) {
                commandString = String(data: data, encoding: .utf8)
            } else {
                fatalError("Could not read file \(inputFile!)\n")
            }
        } else if !(characters ?? "").isEmpty {
            commandString = characters
        }

        if !(applicationName ?? "").isEmpty {
            try AppActivator(appName: applicationName!).activate()
        }

        if (initialDelay > 0) {
            Sleeper.sleep(seconds: initialDelay)
        }

        if !(commandString ?? "").isEmpty {
            commandProcessor.process(commandString!)
        } else if !isTty() {
            var data: Data

            repeat {
                data = FileHandle.standardInput.availableData

                commandString = String(data: data, encoding: .utf8)
                commandProcessor.process(commandString!)
            } while data.count > 0
        } else {
            print(SendKeysCli.helpMessage())
        }
    }

    private func isTty() -> Bool {
        return isatty(FileHandle.standardInput.fileDescriptor) == 1
    }
}
