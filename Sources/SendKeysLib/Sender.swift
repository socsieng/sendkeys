import ArgumentParser
import Cocoa
import Foundation

@available(OSX 10.11, *)
public struct Sender: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "send",
        abstract: "Sends keystroke and mouse event commands."
    )

    @Option(name: .shortAndLong, help: "Name of a running application to send keys to.")
    var applicationName: String?

    @Option(
        name: NameSpecification([.short, .customLong("pid")]),
        help: "Process id of a running application to send keys to.")
    var processId: Int?

    @Flag(
        name: .long, inversion: FlagInversion.prefixedNo,
        help: "Activate the specified app or process before sending commands.")
    var activate: Bool?

    @Flag(
        name: .long, inversion: FlagInversion.prefixedNo, help: "Only send keystrokes to the targeted app or process.")
    var targeted: Bool?

    @Option(name: .shortAndLong, help: "Default delay between keystrokes in seconds.")
    var delay: Double?

    @Option(name: .shortAndLong, help: "Initial delay before sending commands in seconds.")
    var initialDelay: Double?

    @Option(name: NameSpecification([.customShort("f"), .long]), help: "File containing keystroke instructions.")
    var inputFile: String?

    @Option(name: .shortAndLong, help: "String of characters to send.")
    var characters: String?

    @Option(help: "Number of seconds between animation updates.")
    var animationInterval: Double?

    @Option(name: .shortAndLong, help: "Character sequence to use to terminate execution (e.g. f12:command).")
    var terminateCommand: String?

    @Option(name: .long, help: "Keyboard layout to use for sending keystrokes.")
    var keyboardLayout: KeyMappings.Layouts?

    var config: SendConfig

    public init() {
        self.config = SendConfig(
            activate: true, animationInterval: 0.01, delay: 0.1, initialDelay: 1,
            targeted: false, terminateCommand: nil)
    }

    public mutating func run() throws {
        let accessEnabled = AXIsProcessTrustedWithOptions(
            [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)

        if !accessEnabled {
            fputs(
                "WARNING: Accessibility preferences must be enabled to use this tool. If running from the terminal, make sure that your terminal app has accessibility permissiions enabled.\n\n",
                stderr)
        }

        let activator = AppActivator(appName: applicationName, processId: processId)
        let app: NSRunningApplication? = try activator.find()
        let keyPresser: KeyPresser

        self.config = self.config
            .merge(with: ConfigLoader.loadConfig().send)
            .merge(
                with: SendConfig(
                    activate: activate, animationInterval: animationInterval, delay: delay, initialDelay: initialDelay,
                    keyboardLayout: keyboardLayout, targeted: targeted, terminateCommand: terminateCommand))

        let activate = activate ?? self.config.activate!
        let targeted = targeted ?? self.config.targeted!
        let delay = delay ?? self.config.delay!
        let initialDelay = initialDelay ?? self.config.initialDelay!
        let animationInterval = animationInterval ?? self.config.animationInterval!
        let terminateCommand = terminateCommand ?? self.config.terminateCommand
        let keyboardLayout = keyboardLayout ?? self.config.keyboardLayout

        if keyboardLayout != nil {
            KeyPresser.setKeyboardLayout(keyboardLayout!)
        }

        if self.config.remap != nil {
            KeyCodes.updateMapping(self.config.remap!)
        }

        if targeted {
            if app == nil {
                throw RuntimeError("Application could not be found.")
            }
            keyPresser = KeyPresser(app: app)
        } else {
            keyPresser = KeyPresser(app: nil)
        }

        let mouseController = MouseController(animationRefreshInterval: animationInterval, keyPresser: keyPresser)
        let commandProcessor = CommandsProcessor(
            defaultPause: delay, keyPresser: keyPresser, mouseController: mouseController)
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

        var listener: TerminationListener?
        if terminateCommand != nil && !terminateCommand!.isEmpty {
            listener = TerminationListener(sequence: terminateCommand!) {
                Sender.exit()
            }
            listener!.listen()
        }

        if activate {
            try activator.activate()
        }

        if initialDelay > 0 {
            Sleeper.sleep(seconds: initialDelay)
        }

        if !(commandString ?? "").isEmpty {
            commandProcessor.process(commandString!)
            Sleeper.sleep(seconds: 0.01)
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

        if listener != nil {
            listener!.stop()
        }
    }
}
