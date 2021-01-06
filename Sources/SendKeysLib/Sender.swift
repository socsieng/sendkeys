import ArgumentParser
import Foundation

@available(OSX 10.11, *)
public struct Sender: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "send",
        abstract: "Sends keystroke and mouse event commands."
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

    @Option(help: "Number of seconds between animation updates.")
    var animationInterval: Double = 0.01

    public init() { }

    public mutating func run() throws {
        let accessEnabled = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)

        if !accessEnabled {
            fputs("WARNING: Accessibility preferences must be enabled to use this tool. If running from the terminal, make sure that your terminal app has accessibility permissiions enabled.\n\n", stderr)
        }

        let keyPresser = KeyPresser()
        let mouseController = MouseController(animationRefreshInterval: animationInterval)
        let commandProcessor = CommandsProcessor(defaultPause: delay, keyPresser: keyPresser, mouseController: mouseController)
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

                if data.count > 0 {
                    commandString = String(data: data, encoding: .utf8)
                    commandProcessor.process(commandString!)
                }
            } while data.count > 0
        } else {
            print(SendKeysCli.helpMessage(for: Self.self))
        }
    }
}
