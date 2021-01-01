import Foundation

public class MouseDragCommandMatcher: CommandMatcher {
    public init() {
        super.init(try! NSRegularExpression(pattern: "\\<d:((\\d+),(\\d+),)?(\\d+),(\\d+)(:([\\d.]+))?(:([a-z]+))?(:([a-z,]+))?\\>"))
    }

    override public func createCommand(_ arguments: [String?]) -> Command {
        let x1 = arguments[2]
        let y1 = arguments[3]
        let x2 = arguments[4]
        let y2 = arguments[5]
        let duration = arguments[7]
        let button = arguments[9]
        let modifiers = arguments[11]

        return Command(.mouseDrag, [
            x1 ?? "-1",
            y1 ?? "-1",
            x2!,
            y2!,
            duration ?? "0",
            button ?? "left",
            modifiers
        ])
    }
}
