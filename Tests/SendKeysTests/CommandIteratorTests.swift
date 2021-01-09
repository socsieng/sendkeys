import XCTest

@testable import SendKeysLib

final class CommandIteratorTests: XCTestCase {
    func testParsesCharacters() throws {
        let commands = getCommands(CommandsIterator("abc"))
        XCTAssertEqual(
            commands,
            [
                DefaultCommand(key: "a"),
                DefaultCommand(key: "b"),
                DefaultCommand(key: "c"),
            ])
    }

    func testParsesKeyPress() throws {
        let commands = getCommands(CommandsIterator("<c:a>"))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyPressDelete() throws {
        let commands = getCommands(CommandsIterator("<c:delete>"))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "delete", modifiers: [])
            ])
    }

    func testParsesKeyPressesWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<c:a:command>"))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: ["command"])
            ])
    }

    func testParsesKeyPressesWithModifierKeys() throws {
        let commands = getCommands(CommandsIterator("<c:a:command,shift>"))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: ["command", "shift"])
            ])
    }

    func testParsesKeyPressAlias() throws {
        let commands = getCommands(CommandsIterator("<k:a>"))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyDown() throws {
        let commands = getCommands(CommandsIterator("<kd:a>"))
        XCTAssertEqual(
            commands,
            [
                KeyDownCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyDownWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<kd:a:shift>"))
        XCTAssertEqual(
            commands,
            [
                KeyDownCommand(key: "a", modifiers: ["shift"])
            ])
    }

    func testParsesKeyDownAsModifierKey() throws {
        let commands = getCommands(CommandsIterator("<kd:shift>"))
        XCTAssertEqual(
            commands,
            [
                KeyDownCommand(key: "shift", modifiers: [])
            ])
    }

    func testParsesKeyUp() throws {
        let commands = getCommands(CommandsIterator("<ku:a>"))
        XCTAssertEqual(
            commands,
            [
                KeyUpCommand(key: "a", modifiers: [])
            ])
    }

    func testParsesKeyUpWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<ku:a:shift>"))
        XCTAssertEqual(
            commands,
            [
                KeyUpCommand(key: "a", modifiers: ["shift"])
            ])
    }

    func testParsesKeyUpAsModifierKey() throws {
        let commands = getCommands(CommandsIterator("<ku:shift>"))
        XCTAssertEqual(
            commands,
            [
                KeyUpCommand(key: "shift", modifiers: [])
            ])
    }

    func testParsesNewLines() throws {
        let commands = getCommands(CommandsIterator("\n\n\n"))
        XCTAssertEqual(
            commands,
            [
                NewlineCommand(),
                NewlineCommand(),
                NewlineCommand(),
            ])
    }

    func testParsesNewLinesWithCarriageReturns() throws {
        let commands = getCommands(CommandsIterator("\r\n\r\n\n"))
        XCTAssertEqual(
            commands,
            [
                NewlineCommand(),
                NewlineCommand(),
                NewlineCommand(),
            ])
    }

    func testParsesMultipleKeyPresses() throws {
        let commands = getCommands(CommandsIterator("<c:a:command><c:c:command>"))
        XCTAssertEqual(
            commands,
            [
                KeyPressCommand(key: "a", modifiers: ["command"]),
                KeyPressCommand(key: "c", modifiers: ["command"]),
            ])
    }

    func testParsesContinuation() throws {
        let commands = getCommands(CommandsIterator("<\\>"))
        XCTAssertEqual(
            commands,
            [
                ContinuationCommand()
            ])
    }

    func testParsesPause() throws {
        let commands = getCommands(CommandsIterator("<p:0.2>"))
        XCTAssertEqual(
            commands,
            [
                PauseCommand(duration: 0.2)
            ])
    }

    func testParsesStickyPause() throws {
        let commands = getCommands(CommandsIterator("<P:0.2>"))
        XCTAssertEqual(
            commands,
            [
                StickyPauseCommand(duration: 0.2)
            ])
    }

    func testParsesMouseMove() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, modifiers: [])
            ])
    }

    func testParsesMouseMoveWithModifier() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:command>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, modifiers: ["command"])
            ])
    }

    func testParsesMouseMoveWithDuration() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:0.1>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, modifiers: [])
            ])
    }

    func testParsesMouseMoveWithNegativeCoordinates() throws {
        let commands = getCommands(CommandsIterator("<m:-1,-2,-3,-4:0.1>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: -1, y1: -2, x2: -3, y2: -4, duration: 0.1, modifiers: [])
            ])
    }

    func testParsesMouseMoveWithDurationAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:0.1:shift,command>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, modifiers: ["shift", "command"])
            ])
    }

    func testParsesPartialMouseMove() throws {
        let commands = getCommands(CommandsIterator("<m:3,4>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 0, modifiers: [])
            ])
    }

    func testParsesPartialMouseMoveWithDuration() throws {
        let commands = getCommands(CommandsIterator("<m:3,4:2>"))
        XCTAssertEqual(
            commands,
            [
                MouseMoveCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 2, modifiers: [])
            ])
    }

    func testParsesMouseClick() throws {
        let commands = getCommands(CommandsIterator("<m:left>"))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "left", modifiers: [], clicks: 1)
            ])
    }

    func testParsesMouseClickWithModifiers() throws {
        let commands = getCommands(CommandsIterator("<m:left:shift,command>"))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "left", modifiers: ["shift", "command"], clicks: 1)
            ])
    }

    func testParsesMouseClickWithClickCount() throws {
        let commands = getCommands(CommandsIterator("<m:right:2>"))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "right", modifiers: [], clicks: 2)
            ])
    }

    func testParsesMouseClickWithModifiersAndClickCount() throws {
        let commands = getCommands(CommandsIterator("<m:right:command:2>"))
        XCTAssertEqual(
            commands,
            [
                MouseClickCommand(button: "right", modifiers: ["command"], clicks: 2)
            ])
    }

    func testParsesMouseDrag() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, button: "left", modifiers: [])
            ])
    }

    func testParsesMouseDragWithButton() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:right>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, button: "right", modifiers: [])
            ])
    }

    func testParsesMouseDragWithButtonAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:right:command,shift>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(
                    x1: 1, y1: 2, x2: 3, y2: 4, duration: 0, button: "right", modifiers: ["command", "shift"])
            ])
    }

    func testParsesMouseDragWithDuration() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, button: "left", modifiers: [])
            ])
    }

    func testParsesMouseDragWithDurationWithNegativeCoordinates() throws {
        let commands = getCommands(CommandsIterator("<d:-1,-2,-3,-4:0.1>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: -1, y1: -2, x2: -3, y2: -4, duration: 0.1, button: "left", modifiers: [])
            ])
    }

    func testParsesMouseDragWithDurationAndButton() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1:right>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, button: "right", modifiers: [])
            ])
    }

    func testParsesMouseDragWithDurationAndButtonAndModifier() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1:right:command>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: 1, y1: 2, x2: 3, y2: 4, duration: 0.1, button: "right", modifiers: ["command"])
            ])
    }

    func testParsesPartialMouseDrag() throws {
        let commands = getCommands(CommandsIterator("<d:3,4>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 0, button: "left", modifiers: [])
            ])
    }

    func testParsesPartialMouseDragWithDuration() throws {
        let commands = getCommands(CommandsIterator("<d:3,4:2>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 2, button: "left", modifiers: [])
            ])
    }

    func testParsesPartialMouseDragWithDurationAndButton() throws {
        let commands = getCommands(CommandsIterator("<d:3,4:2:center>"))
        XCTAssertEqual(
            commands,
            [
                MouseDragCommand(x1: nil, y1: nil, x2: 3, y2: 4, duration: 2, button: "center", modifiers: [])
            ])
    }

    func testParsesMouseScroll() throws {
        let commands = getCommands(CommandsIterator("<s:0,10>"))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: 10, duration: 0, modifiers: [])
            ])
    }

    func testParsesMouseScrollWithNegativeAmount() throws {
        let commands = getCommands(CommandsIterator("<s:-100,10>"))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: -100, y: 10, duration: 0, modifiers: [])
            ])
    }

    func testParsesMouseScrollWithDuration() throws {
        let commands = getCommands(CommandsIterator("<s:0,10:0.5>"))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: 10, duration: 0.5, modifiers: [])
            ])
    }

    func testParsesMouseScrollWithDurationAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<s:0,10:0.5:shift>"))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: 10, duration: 0.5, modifiers: ["shift"])
            ])
    }

    func testParsesMouseScrollWithNegativeAmountAndDuration() throws {
        let commands = getCommands(CommandsIterator("<s:0,-10:0.5>"))
        XCTAssertEqual(
            commands,
            [
                MouseScrollCommand(x: 0, y: -10, duration: 0.5, modifiers: [])
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
