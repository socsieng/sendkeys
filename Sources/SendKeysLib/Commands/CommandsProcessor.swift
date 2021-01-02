import Foundation

public class CommandsProcessor {
    var defaultPause: TimeInterval
    
    let numberFormatter = NumberFormatter()
    let commandExecutor: CommandExecutorProtocol
    
    public init(defaultPause: Double, commandExecutor: CommandExecutorProtocol? = nil) {
        self.defaultPause = defaultPause
        self.commandExecutor = commandExecutor ?? CommandExecutor()
        
        numberFormatter.usesSignificantDigits = true
        numberFormatter.minimumSignificantDigits = 1
        numberFormatter.maximumSignificantDigits = 3
    }
        
    private func getDefaultPauseCommand() -> Command {
        return PauseCommand(duration: defaultPause)
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
            
            if command is ContinuationCommand {
                shouldIgnoreNextCommand = true
                continue
            }

            if command is StickyPauseCommand {
                shouldDefaultPause = false
                defaultPause = (command as! StickyPauseCommand).duration
            } else if command is PauseCommand {
                shouldDefaultPause = false
            } else if shouldDefaultPause {
                commandExecutor.execute(getDefaultPauseCommand())
                shouldDefaultPause = true
            } else {
                shouldDefaultPause = true
            }
            
            commandExecutor.execute(command)
        }
    }
}
