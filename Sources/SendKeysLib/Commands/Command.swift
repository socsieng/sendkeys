public enum CommandType {
    case keyPress
    case keyDown
    case keyUp
    case pause
    case stickyPause
    case mouseMove
    case mouseClick
    case mouseDrag
    case mouseScroll
    case continuation
}

public struct Command: Equatable {
    let type: CommandType
    let arguments: [String?]

    public init(_ type: CommandType, _ arguments: [String?]) {
        self.type = type
        self.arguments = arguments
    }

    public init(_ type: CommandType) {
        self.init(type, [])
    }

    public static func == (lhs: Command, rhs: Command) -> Bool {
        return lhs.type == rhs.type && lhs.arguments == rhs.arguments;
    }
}
