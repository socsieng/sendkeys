import Foundation

public enum CommandType {
    case undefined
    case keyPress
    case keyDown
    case keyUp
    case pause
    case stickyPause
    case mouseMove
    case mouseClick
    case mouseDrag
    case mouseScroll
    case mouseDown
    case mouseUp
    case continuation
}

public protocol CommandProtocol {
    static var commandType: CommandType { get }
    static var expression: NSRegularExpression { get }

    init(arguments: [String?])
    func execute() throws
    func equals(_ comparison: Command) -> Bool
}

protocol RequiresKeyPresser {
    var keyPresser: KeyPresser? { get set }
}

protocol RequiresMouseController {
    var mouseController: MouseController? { get set }
}

public class Command: Equatable, CustomStringConvertible {
    public class var commandType: CommandType { return .undefined }

    private static let _expression = try! NSRegularExpression(pattern: ".")
    public class var expression: NSRegularExpression { return _expression }

    init() {}

    required public init(arguments: [String?]) {
    }

    public func execute() throws {
    }

    public func equals(_ comparison: Command) -> Bool {
        return type(of: self) == type(of: comparison)
    }

    public static func == (lhs: Command, rhs: Command) -> Bool {
        return lhs.equals(rhs) && rhs.equals(lhs)
    }

    public var description: String {
        let output = "\(type(of: self)): \(type(of: self).commandType)"
        let members = describeMembers()

        if !members.isEmpty {
            return "\(output) (\(members))"
        }

        return output
    }

    func describeMembers() -> String {
        return ""
    }
}
