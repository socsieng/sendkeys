import XCTest

@testable import SendKeysLib

final class CommandIteratorTests: XCTestCase {
    var commandFactory: CommandFactory!

    override func setUp() {
        let keyPresser = KeyPresser(app: nil)
        commandFactory = CommandFactory(
            keyPresser: keyPresser,
            mouseController: MouseController(animationRefreshInterval: 0.01, keyPresser: keyPresser))
    }

    func testParsesCharacters() throws {
        let commands = getCommands(CommandsIterator("abc", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                DefaultCommand(key: "a"),
                DefaultCommand(key: "b"),
                DefaultCommand(key: "c"),
            ])
    }

    func testParsesKeyPress() throws {
        let commands = getCommands(CommandsIterator("<c:a>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyPressDelete() throws {
        let commands = getCommands(CommandsIterator("<c:delete>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "delete", modifiers: [])
            ])
    }

    func testParsesKeyPressesWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<c:a:command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: ["command"])
            ])
    }

    func testParsesKeyPressesWithModifierKeys() throws {
        let commands = getCommands(CommandsIterator("<c:a:command,shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: ["command", "shift"])
            ])
    }

    func testParsesKeyPressAlias() throws {
        let commands = getCommands(CommandsIterator("<k:a>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyDown() throws {
        let commands = getCommands(CommandsIterator("<kd:a>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyDownCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyDownWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<kd:a:shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyDownCommand(key: "a", modifiers: ["shift"])
            ])
    }

    func testParsesKeyDownAsModifierKey() throws {
        let commands = getCommands(CommandsIterator("<kd:shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyDownCommand(key: "shift", modifiers: [])
            ])
    }

    func testParsesKeyUp() throws {
        let commands = getCommands(CommandsIterator("<ku:a>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyUpCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyUpWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<ku:a:shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyUpCommand(key: "a", modifiers: ["shift"])
            ])
    }

    func testParsesKeyUpAsModifierKey() throws {
        let commands = getCommands(CommandsIterator("<ku:shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyUpCommand(key: "shift", modifiers: [])
            ])
    }

    func testParsesNewLines() throws {
        let commands = getCommands(CommandsIterator("\n\n\n", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                NewlineCommand(),
                NewlineCommand(),
                NewlineCommand(),
            ])
    }

    func testParsesNewLinesWithCarriageReturns() throws {
        let commands = getCommands(CommandsIterator("\r\n\r\n\n", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                NewlineCommand(),
                NewlineCommand(),
                NewlineCommand(),
            ])
    }

    func testParsesMultipleKeyPresses() throws {
        let commands = getCommands(CommandsIterator("<c:a:command><c:c:command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: ["command"]),
                KeyPressCommand(key: "c", modifiers: ["command"]),
            ])
    }

    func testParsesContinuation() throws {
        let commands = getCommands(CommandsIterator("<\\>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                ContinuationCommand()
            ])
    }

    func testParsesPause() throws {
        let commands = getCommands(CommandsIterator("<p:0.2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                PauseCommand(duration: 0.2)
            ])
    }

    func testParsesStickyPause() throws {
        let commands = getCommands(CommandsIterator("<P:0.2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                StickyPauseCommand(duration: 0.2)
            ])
    }

    func testParsesMouseMove() throws {
        let commands = getCommands(CommandsIterator("<m:1.5,2.5,3.5,4.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1.5, y1: 2.5, x2: 3.5, y2: 4.5, duration: 0, modifiers: [])
            ])
    }

    func testParsesMouseMoveWithModifier() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, modifiers: ["command"])
            ])
    }

    func testParsesMouseMoveWithDuration() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:0.1>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, modifiers: [])
            ])
    }

    func testParsesMouseMoveWithNegativeCoordinates() throws {
        let commands = getCommands(CommandsIterator("<m:-1,-2,-3,-4:0.1>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: -1, y1: -2, x2: -3, y2: -4, duration: 0.1, modifiers: [])
            ])
    }

    func testParsesMouseMoveWithDurationAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:0.1:shift,command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, modifiers: ["shift", "command"])
            ])
    }

    func testParsesPartialMouseMove() throws {
        let commands = getCommands(CommandsIterator("<m:3,4>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 0, modifiers: [])
            ])
    }

    func testParsesPartialMouseMoveWithDuration() throws {
        let commands = getCommands(CommandsIterator("<m:3,4:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 2, modifiers: [])
            ])
    }

    func testParsesMouseClick() throws {
        let commands = getCommands(CommandsIterator("<m:left>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "left", modifiers: [], clicks: 1)
            ])
    }

    func testParsesMouseClickWithModifiers() throws {
        let commands = getCommands(CommandsIterator("<m:left:shift,command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "left", modifiers: ["shift", "command"], clicks: 1)
            ])
    }

    func testParsesMouseClickWithClickCount() throws {
        let commands = getCommands(CommandsIterator("<m:right:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "right", modifiers: [], clicks: 2)
            ])
    }

    func testParsesMouseClickWithModifiersAndClickCount() throws {
        let commands = getCommands(CommandsIterator("<m:right:command:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "right", modifiers: ["command"], clicks: 2)
            ])
    }

    func testParsesMousePath() throws {
        let commands = getCommands(CommandsIterator("<mpath:L 200 400:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MousePathCommand(
                    path: "L 200 400", offsetX: 0, offsetY: 0, scaleX: 1, scaleY: 1, duration: 2, modifiers: [])
            ])
    }

    func testParsesMousePathWithOffset() throws {
        let commands = getCommands(CommandsIterator("<mpath:L 200 400:100,200:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MousePathCommand(
                    path: "L 200 400", offsetX: 100, offsetY: 200, scaleX: 1, scaleY: 1, duration: 2, modifiers: [])
            ])
    }

    func testParsesMousePathWithOffsetAndScale() throws {
        let commands = getCommands(
            CommandsIterator("<mpath:L 200 400:100,200,0.5,2.5:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MousePathCommand(
                    path: "L 200 400", offsetX: 100, offsetY: 200, scaleX: 0.5, scaleY: 2.5, duration: 2, modifiers: [])
            ])
    }

    func testParsesMousePathWithOffsetAndPartialScale() throws {
        let commands = getCommands(CommandsIterator("<mpath:L 200 400:100,200,0.4:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MousePathCommand(
                    path: "L 200 400", offsetX: 100, offsetY: 200, scaleX: 0.4, scaleY: 0.4, duration: 2, modifiers: [])
            ])
    }

    func testParsesMouseDrag() throws {
        let commands = getCommands(CommandsIterator("<d:1.5,2.5,3.5,4.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1.5, y1: 2.5, x2: 3.5, y2: 4.5, duration: 0, button: "left", modifiers: [])
            ])
    }

    func testParsesMouseDragWithButton() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:right>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, button: "right", modifiers: [])
            ])
    }

    func testParsesMouseDragWithButtonAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:right:command,shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(
                    x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, button: "right", modifiers: ["command", "shift"])
            ])
    }

    func testParsesMouseDragWithDuration() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, button: "left", modifiers: [])
            ])
    }

    func testParsesMouseDragWithDurationWithNegativeCoordinates() throws {
        let commands = getCommands(CommandsIterator("<d:-1.5,-2,-3,-4:0.1>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: -1.5, y1: -2, x2: -3, y2: -4, duration: 0.1, button: "left", modifiers: [])
            ])
    }

    func testParsesMouseDragWithDurationAndButton() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1:right>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, button: "right", modifiers: [])
            ])
    }

    func testParsesMouseDragWithDurationAndButtonAndModifier() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1:right:command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, button: "right", modifiers: ["command"])
            ])
    }

    func testParsesPartialMouseDrag() throws {
        let commands = getCommands(CommandsIterator("<d:3,4>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 0, button: "left", modifiers: [])
            ])
    }

    func testParsesPartialMouseDragWithDuration() throws {
        let commands = getCommands(CommandsIterator("<d:3,4:2>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 2, button: "left", modifiers: [])
            ])
    }

    func testParsesPartialMouseDragWithDurationAndButton() throws {
        let commands = getCommands(CommandsIterator("<d:3,4:2:center>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 2, button: "center", modifiers: [])
            ])
    }

    func testParsesMouseScroll() throws {
        let commands = getCommands(CommandsIterator("<s:0,10.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: 10.5, duration: 0, modifiers: [])
            ])
    }

    func testParsesMouseScrollWithNegativeAmount() throws {
        let commands = getCommands(CommandsIterator("<s:-100,10>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: -100, y: 10, duration: 0, modifiers: [])
            ])
    }

    func testParsesMouseScrollWithDuration() throws {
        let commands = getCommands(CommandsIterator("<s:0,10:0.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: 10, duration: 0.5, modifiers: [])
            ])
    }

    func testParsesMouseScrollWithDurationAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<s:0,10:0.5:shift>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: 10, duration: 0.5, modifiers: ["shift"])
            ])
    }

    func testParsesMouseScrollWithNegativeAmountAndDuration() throws {
        let commands = getCommands(CommandsIterator("<s:0,-10:0.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: -10, duration: 0.5, modifiers: [])
            ])
    }

    func testParsesMouseDown() throws {
        let commands = getCommands(CommandsIterator("<md:right>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDownCommand(button: "right", modifiers: [])
            ])
    }

    func testParsesMouseDownWithModifiers() throws {
        let commands = getCommands(CommandsIterator("<md:left:shift,command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseDownCommand(button: "left", modifiers: ["shift", "command"])
            ])
    }

    func testParsesMouseUp() throws {
        let commands = getCommands(CommandsIterator("<mu:center>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseUpCommand(button: "center", modifiers: [])
            ])
    }

    func testParsesMouseUpWithModifiers() throws {
        let commands = getCommands(CommandsIterator("<mu:right:option,command>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseUpCommand(button: "right", modifiers: ["option", "command"])
            ])
    }

    func testParsesMouseFocus() throws {
        let commands = getCommands(
            CommandsIterator("<mf:0.5,0.5:100.5,50.5:0.5,360.5:1>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseFocusCommand(x: 0.5, y: 0.5, rx: 100.5, ry: 50.5, angleFrom: 0.5, angleTo: 360.5, duration: 1)
            ])
    }

    func testParsesMouseFocusWithSingleRadius() throws {
        let commands = getCommands(CommandsIterator("<mf:0,0:100:0,360:0.1>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseFocusCommand(x: 0, y: 0, rx: 100, ry: 100, angleFrom: 0, angleTo: 360, duration: 0.1)
            ])
    }

    func testParsesMouseFocusWithNegativeCoordinates() throws {
        let commands = getCommands(CommandsIterator("<mf:-10,-20:100,50:0,360:1.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseFocusCommand(x: -10, y: -20, rx: 100, ry: 50, angleFrom: 0, angleTo: 360, duration: 1.5)
            ])
    }

    func testParsesMouseFocusWithNegativeAngles() throws {
        let commands = getCommands(CommandsIterator("<mf:-10,-20:100,50:100,-360:1.5>", commandFactory: commandFactory))
        XCTAssertEqual(
            commands,
            [
                MouseFocusCommand(x: -10, y: -20, rx: 100, ry: 50, angleFrom: 100, angleTo: -360, duration: 1.5)
            ])
    }

    private func getCommands(_ iterator: CommandsIterator) -> [Command] {
        var commands: [Command] = []

        while true {
            let command = iterator.next()

            if command == nil {
                break
            }

            commands.append(command!)
        }

        return commands
    }
}
