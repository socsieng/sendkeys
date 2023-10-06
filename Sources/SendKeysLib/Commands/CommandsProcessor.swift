import Foundation

public class CommandsProcessor {
    var defaultPause: TimeInterval

    let numberFormatter = NumberFormatter()
    let commandExecutor: CommandExecutorProtocol
    let keyPresser: KeyPresser
    let mouseController: MouseController

    init(
        defaultPause: Double, keyPresser: KeyPresser, mouseController: MouseController,
        commandExecutor: CommandExecutorProtocol? = nil
    ) {
        self.defaultPause = defaultPause
        self.commandExecutor = commandExecutor ?? CommandExecutor()
        self.keyPresser = keyPresser
        self.mouseController = mouseController

        numberFormatter.usesSignificantDigits = true
        numberFormatter.minimumSignificantDigits = 1
        numberFormatter.maximumSignificantDigits = 3
    }

    convenience public init(
        defaultPause: Double, keyPresser: KeyPresser, commandExecutor: CommandExecutorProtocol? = nil
    ) {
        self.init(
            defaultPause: defaultPause, keyPresser: keyPresser,
            mouseController: MouseController(animationRefreshInterval: 0.01, keyPresser: keyPresser),
            commandExecutor: commandExecutor)
    }

    private func getDefaultPauseCommand() -> Command {
        return PauseCommand(duration: defaultPause)
    }

    public func process(_ commandString: String) {
        let commandFactory = CommandFactory(keyPresser: keyPresser, mouseController: mouseController)
        let commands = IteratorSequence(CommandsIterator(commandString, commandFactory: commandFactory))
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
