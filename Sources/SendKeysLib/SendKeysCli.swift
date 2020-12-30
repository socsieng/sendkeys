import ArgumentParser
import Foundation

@available(OSX 10.11, *)
public struct SendKeysCli: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "sendkeys",
        abstract: "Command line tool for automating keystrokes and mouse events"
        // subcommands: [Generate.self]
    )
    
    @Option(name: .shortAndLong, help: "Name of the application to send keys to.")
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
        if !(applicationName ?? "").isEmpty {
            try AppActivator(appName: applicationName!).activate()
        }
        
        if (initialDelay > 0) {
            Sleeper.sleep(seconds: initialDelay)
        }
        
        let commandProcessor = CommandsProcessor(defaultPause: delay)
        var commandString: String?
        
        if !(inputFile ?? "").isEmpty {
            let directoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileUrl = URL(fileURLWithPath: inputFile!, relativeTo: directoryUrl)
            
            let data = try! Data(contentsOf: fileUrl)
            commandString = String(data: data, encoding: .utf8)
        } else if !(characters ?? "").isEmpty {
            commandString = characters
        }
        
        if !(commandString ?? "").isEmpty {
            commandProcessor.process(commandString!)
        } else {
            var data: Data
            
            repeat {
                data = FileHandle.standardInput.availableData
                commandString = String(data: data, encoding: .utf8)
                commandProcessor.process(commandString!)
            } while data.count > 0
        }
    }
}
