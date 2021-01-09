import Foundation

public class StickyPauseCommand: PauseCommand {
    public override class var commandType: CommandType { return .stickyPause }

    private static let _expression = try! NSRegularExpression(pattern: "\\<P:([\\d.]+)\\>")
    public override class var expression: NSRegularExpression { return _expression }
}
