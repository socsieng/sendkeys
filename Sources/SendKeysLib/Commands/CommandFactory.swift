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
        DefaultCommand.self
    ]

    public static func create(_ commandType: Command.Type, arguments: [String?]) -> Command {
        return commandType.init(arguments: arguments)
    }
}
