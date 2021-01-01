import Foundation

public class KeyUpCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<ku:(.|[\\w]+)(:([,\\w⌘^⌥⇧]+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        var args = [arguments[1]!]
        if arguments[3] != nil {
            args.append(arguments[3]!)
        }
        return Command(.keyUp, args)
    }
}
