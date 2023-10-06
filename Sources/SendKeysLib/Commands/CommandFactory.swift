public class CommandFactory {
    public static let commands: [Command.Type] = [
        KeyPressCommand.self,
        KeyDownCommand.self,
        KeyUpCommand.self,
        StickyPauseCommand.self,
        PauseCommand.self,
        ContinuationCommand.self,
        NewlineCommand.self,
        MouseMoveCommand.self,
        MousePathCommand.self,
        MouseClickCommand.self,
        MouseDragCommand.self,
        MouseScrollCommand.self,
        MouseDownCommand.self,
        MouseUpCommand.self,
        MouseFocusCommand.self,
        DefaultCommand.self,
    ]

    let keyPresser: KeyPresser
    let mouseController: MouseController

    init(keyPresser: KeyPresser, mouseController: MouseController) {
        self.keyPresser = keyPresser
        self.mouseController = mouseController
    }

    convenience public init(keyPresser: KeyPresser) {
        self.init(
            keyPresser: keyPresser,
            mouseController: MouseController(animationRefreshInterval: 0.01, keyPresser: keyPresser))
    }

    public func create(_ commandType: Command.Type, arguments: [String?]) -> Command {
        let command = commandType.init(arguments: arguments)

        if var keyCommand = command as? RequiresKeyPresser {
            keyCommand.keyPresser = keyPresser
        }

        if var mouseCommand = command as? RequiresMouseController {
            mouseCommand.mouseController = mouseController
        }

        return command
    }
}
