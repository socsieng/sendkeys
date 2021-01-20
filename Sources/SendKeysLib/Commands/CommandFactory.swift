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

    convenience public init() {
        self.init(keyPresser: KeyPresser(), mouseController: MouseController(animationRefreshInterval: 0.01))
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
