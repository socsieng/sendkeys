import Foundation

public protocol CommandExecutorProtocol {
    func execute(_ command: Command)
}

public class CommandExecutor: CommandExecutorProtocol {
    private let keyPresser = KeyPresser()
    private let mouseController = MouseController()
    
    public func execute(_ command: Command) {
        switch command.type {
        case .keyPress:
            executeKeyPress(command)
        case .pause, .stickyPause:
            executePause(command)
        case .mouseMove:
            executeMouseMove(command)
        case .mouseClick:
            executeMouseClick(command)
        case .mouseDrag:
            executeMouseDrag(command)
        case .mouseScroll:
            executeMouseScroll(command)
        default:
            fatalError("Unrecognized command type \(command.type)\n")
        }
    }
    
    private func executeKeyPress(_ command: Command) {
        var modifiers: [String] = []
        
        if command.arguments.count > 1 {
            modifiers = command.arguments[1]!.components(separatedBy: ",")
        }
        
        try! keyPresser.keyPress(key: command.arguments[0]!, modifiers: modifiers)
    }
    
    private func executePause(_ command: Command) {
        Sleeper.sleep(seconds: Double(command.arguments[0]!)!)
    }
    
    private func executeMouseMove(_ command: Command) {
        let x1 = Double(command.arguments[0]!)!
        let y1 = Double(command.arguments[1]!)!
        let x2 = Double(command.arguments[2]!)!
        let y2 = Double(command.arguments[3]!)!
        let duration: TimeInterval = Double(command.arguments[4]!)!
        let modifiers = command.arguments[5]
        
        mouseController.move(
            start: CGPoint(x: x1, y: y1),
            end: CGPoint(x: x2, y: y2),
            duration: duration,
            flags: modifiers != nil ? try! KeyPresser.getModifierFlags(modifiers!.components(separatedBy: ",")) : []
        )
    }
    
    private func executeMouseClick(_ command: Command) {
        let button = command.arguments[0]!
        let modifiers = command.arguments[1]
        let clicks = Int(command.arguments[2]!)!

        try! mouseController.click(
            CGPoint(x: -1, y: -1),
            button: getMouseButton(button: button),
            flags: modifiers != nil ? try! KeyPresser.getModifierFlags(modifiers!.components(separatedBy: ",")) : [],
            clickCount: clicks
        )
    }
    
    private func executeMouseScroll(_ command: Command) {
        let x = Int(command.arguments[0]!) ?? 0
        let y = Int(command.arguments[1]!) ?? 0
        let duration = Double(command.arguments[2] ?? "0") ?? 0

        mouseController.scroll(
            CGPoint(x: x, y: y),
            duration
        )
    }

    private func executeMouseDrag(_ command: Command) {
        let x1 = Double(command.arguments[0]!)!
        let y1 = Double(command.arguments[1]!)!
        let x2 = Double(command.arguments[2]!)!
        let y2 = Double(command.arguments[3]!)!
        let duration: TimeInterval = Double(command.arguments[4]!)!
        let button = command.arguments[5]!
        let modifiers = command.arguments[6]

        try! mouseController.drag(
            start: CGPoint(x: x1, y: y1),
            end: CGPoint(x: x2, y: y2),
            duration: duration,
            button: getMouseButton(button: button),
            flags: modifiers != nil ? try! KeyPresser.getModifierFlags(modifiers!.components(separatedBy: ",")) : []
        )
    }
    
    private func getMouseButton(button: String) throws -> CGMouseButton {
        switch button {
        case "left":
            return CGMouseButton.left
        case "center":
            return CGMouseButton.center
        case "right":
            return CGMouseButton.right
        default:
            throw RuntimeError("Unknown mouse button: \(button)")
        }
    }
}
