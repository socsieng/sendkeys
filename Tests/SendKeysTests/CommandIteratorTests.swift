@testable import SendKeysLib

import XCTest

final class CommandIteratorTests: XCTestCase {
    func testParsesCharacters() throws {
        let commands = getCommands(CommandsIterator("abc"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["a"]),
                Command(CommandType.keyPress, ["b"]),
                Command(CommandType.keyPress, ["c"])
            ])
    }

    func testParsesKeyPress() throws {
        let commands = getCommands(CommandsIterator("<c:a>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["a"])
            ])
    }

    func testParsesKeyPressesWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<c:a:command>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["a", "command"])
            ])
    }

    func testParsesKeyPressesWithModifierKeys() throws {
        let commands = getCommands(CommandsIterator("<c:a:command,shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["a", "command,shift"])
            ])
    }

    func testParsesKeyPressAlias() throws {
        let commands = getCommands(CommandsIterator("<k:a>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["a"])
            ])
    }

    func testParsesKeyDown() throws {
        let commands = getCommands(CommandsIterator("<kd:a>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyDown, ["a"])
            ])
    }

    func testParsesKeyDownWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<kd:a:shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyDown, ["a", "shift"])
            ])
    }

    func testParsesKeyDownAsModifierKey() throws {
        let commands = getCommands(CommandsIterator("<kd:shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyDown, ["shift"])
            ])
    }

    func testParsesKeyUp() throws {
        let commands = getCommands(CommandsIterator("<ku:a>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyUp, ["a"])
            ])
    }

    func testParsesKeyUpWithModifierKey() throws {
        let commands = getCommands(CommandsIterator("<ku:a:shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyUp, ["a", "shift"])
            ])
    }

    func testParsesKeyUpAsModifierKey() throws {
        let commands = getCommands(CommandsIterator("<ku:shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyUp, ["shift"])
            ])
    }

    func testParsesNewLines() throws {
        let commands = getCommands(CommandsIterator("\n\n\n"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["return"]),
                Command(CommandType.keyPress, ["return"]),
                Command(CommandType.keyPress, ["return"])
            ])
    }

    func testParsesNewLinesWithCarriageReturns() throws {
        let commands = getCommands(CommandsIterator("\r\n\r\n\n"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["return"]),
                Command(CommandType.keyPress, ["return"]),
                Command(CommandType.keyPress, ["return"])
            ])
    }

    func testParsesMultipleKeyPresses() throws {
        let commands = getCommands(CommandsIterator("<c:a:command><c:c:command>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.keyPress, ["a", "command"]),
                Command(CommandType.keyPress, ["c", "command"])
            ])
    }

    func testParsesContinuation() throws {
        let commands = getCommands(CommandsIterator("<\\>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.continuation, [])
            ])
    }

    func testParsesPause() throws {
        let commands = getCommands(CommandsIterator("<p:0.2>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.pause, ["0.2"])
            ])
    }

    func testParsesStickyPause() throws {
        let commands = getCommands(CommandsIterator("<P:0.2>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.stickyPause, ["0.2"])
            ])
    }

    func testParsesMouseMove() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseMove, ["1", "2", "3", "4", "0", nil])
            ])
    }

    func testParsesMouseMoveWithModifier() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:command>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseMove, ["1", "2", "3", "4", "0", "command"])
            ])
    }

    func testParsesMouseMoveWithDuration() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:0.1>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseMove, ["1", "2", "3", "4", "0.1", nil])
            ])
    }

    func testParsesMouseMoveWithDurationAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<m:1,2,3,4:0.1:shift,command>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseMove, ["1", "2", "3", "4", "0.1", "shift,command"])
            ])
    }

    func testParsesPartialMouseMove() throws {
        let commands = getCommands(CommandsIterator("<m:3,4>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseMove, ["-1", "-1", "3", "4", "0", nil])
            ])
    }

    func testParsesPartialMouseMoveWithDuration() throws {
        let commands = getCommands(CommandsIterator("<m:3,4:2>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseMove, ["-1", "-1", "3", "4", "2", nil])
            ])
    }

    func testParsesMouseClick() throws {
        let commands = getCommands(CommandsIterator("<m:left>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseClick, ["left", nil, "1"])
            ])
    }

    func testParsesMouseClickWithModifiers() throws {
        let commands = getCommands(CommandsIterator("<m:left:shift,command>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseClick, ["left", "shift,command", "1"])
            ])
    }

    func testParsesMouseClickWithClickCount() throws {
        let commands = getCommands(CommandsIterator("<m:right:2>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseClick, ["right", nil, "2"])
            ])
    }

    func testParsesMouseClickWithModifiersAndClickCount() throws {
        let commands = getCommands(CommandsIterator("<m:right:command:2>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseClick, ["right", "command", "2"])
            ])
    }

    func testParsesMouseDrag() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["1", "2", "3", "4", "0", "left", nil])
            ])
    }

    func testParsesMouseDragWithButton() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:right>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["1", "2", "3", "4", "0", "right", nil])
            ])
    }

    func testParsesMouseDragWithButtonAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:right:command,shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["1", "2", "3", "4", "0", "right", "command,shift"])
            ])
    }

    func testParsesMouseDragWithDuration() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["1", "2", "3", "4", "0.1", "left", nil])
            ])
    }

    func testParsesMouseDragWithDurationAndButton() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1:right>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["1", "2", "3", "4", "0.1", "right", nil])
            ])
    }

    func testParsesMouseDragWithDurationAndButtonAndModifier() throws {
        let commands = getCommands(CommandsIterator("<d:1,2,3,4:0.1:right:command>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["1", "2", "3", "4", "0.1", "right", "command"])
            ])
    }

    func testParsesPartialMouseDrag() throws {
        let commands = getCommands(CommandsIterator("<d:3,4>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["-1", "-1", "3", "4", "0", "left", nil])
            ])
    }

    func testParsesPartialMouseDragWithDuration() throws {
        let commands = getCommands(CommandsIterator("<d:3,4:2>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["-1", "-1", "3", "4", "2", "left", nil])
            ])
    }

    func testParsesPartialMouseDragWithDurationAndButton() throws {
        let commands = getCommands(CommandsIterator("<d:3,4:2:center>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseDrag, ["-1", "-1", "3", "4", "2", "center", nil])
            ])
    }

    func testParsesMouseScroll() throws {
        let commands = getCommands(CommandsIterator("<s:0,10>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseScroll, ["0", "10", nil, nil])
            ])
    }

    func testParsesMouseScrollWithNegativeAmount() throws {
        let commands = getCommands(CommandsIterator("<s:-100,10>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseScroll, ["-100", "10", nil, nil])
            ])
    }

    func testParsesMouseScrollWithDuration() throws {
        let commands = getCommands(CommandsIterator("<s:0,10:0.5>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseScroll, ["0", "10", "0.5", nil])
            ])
    }

    func testParsesMouseScrollWithDurationAndModifiers() throws {
        let commands = getCommands(CommandsIterator("<s:0,10:0.5:shift>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseScroll, ["0", "10", "0.5", "shift"])
            ])
    }

    func testParsesMouseScrollWithNegativeAmountAndDuration() throws {
        let commands = getCommands(CommandsIterator("<s:0,-10:0.5>"))
        XCTAssertEqual(
            commands,
            [
                Command(CommandType.mouseScroll, ["0", "-10", "0.5", nil])
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
