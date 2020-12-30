import Foundation

public class MouseMoveCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<m:((\\d+),(\\d+),)?(\\d+),(\\d+)(:([\\d.]+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        let x1 = arguments[2]
        let y1 = arguments[3]
        let x2 = arguments[4]
        let y2 = arguments[5]
        let duration = arguments[7]
        
        return Command(.mouseMove, [
            x1 ?? "-1",
            y1 ?? "-1",
            x2!,
            y2!,
            duration ?? "0"
        ])
    }
}
