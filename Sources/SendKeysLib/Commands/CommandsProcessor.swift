import Foundation

public class CommandsProcessor {
    var defaultPause: Double
    let commandExecutor: CommandExecutorProtocol
    let numberFormatter = NumberFormatter()
    
    public init(defaultPause: Double, commandExecutor: CommandExecutorProtocol? = nil) {
        self.defaultPause = defaultPause
        self.commandExecutor = commandExecutor ?? CommandExecutor()
        
        numberFormatter.usesSignificantDigits = true
        numberFormatter.minimumSignificantDigits = 1
        numberFormatter.maximumSignificantDigits = 3
    }
        
    private func getDefaultPauseCommand() -> Command {
        return Command(.pause, [numberFormatter.string(from: NSNumber(value: defaultPause))!])
    }
    
    public func process(_ commandString: String) {
        let commands = IteratorSequence(CommandsIterator(commandString))
        var shouldDefaultPause = false
        var shouldIgnoreNextCommand = false
        
        for command in commands {
            if shouldIgnoreNextCommand {
                shouldIgnoreNextCommand = false
                continue
            }
            
            if command.type == .continuation {
                shouldIgnoreNextCommand = true
                continue
            }
            
            if command.type == .pause {
                shouldDefaultPause = false
            } else if command.type == .stickyPause {
                shouldDefaultPause = false
                defaultPause = Double(command.arguments[0]!)!
            } else if shouldDefaultPause {
                executeCommand(getDefaultPauseCommand())
                shouldDefaultPause = true
            } else {
                shouldDefaultPause = true
            }

            executeCommand(command)
        }
    }
    
    func executeCommand(_ command: Command) {
        commandExecutor.execute(command)
    }
}
