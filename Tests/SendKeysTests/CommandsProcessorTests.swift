@testable import SendKeysLib

import XCTest

class CommandExecutorSpy: CommandExecutorProtocol {
    var commands: [Command] = []

    func execute(_ command: Command) {
        commands.append(command)
    }
}

final class CommandProcessorTests: XCTestCase {
    var commandExecutor: CommandExecutorSpy?
    var commandsProcessor: CommandsProcessor?

    override func setUp() {
        commandExecutor = CommandExecutorSpy()
        commandsProcessor = CommandsProcessor(defaultPause: 0.1, commandExecutor: commandExecutor)
    }

    func testExecutesSingleKeyPress() {
        commandsProcessor!.process("a")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            DefaultCommand(key: "a")
        ])
    }

    func testExecutesSpecialKeyPress() {
        commandsProcessor!.process("<c:tab>")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            KeyPressCommand(key: "tab", modifiers: [])
        ])
    }

    func testExecutesSpecialKeyPressWithModifier() {
        commandsProcessor!.process("<c:tab:shift>")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            KeyPressCommand(key: "tab", modifiers: ["shift"])
        ])
    }

    func testExecutesMultipleKeyPressWithDelay() {
        commandsProcessor!.process("hello")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            DefaultCommand(key: "h"),
            PauseCommand(duration: 0.1),
            DefaultCommand(key: "e"),
            PauseCommand(duration: 0.1),
            DefaultCommand(key: "l"),
            PauseCommand(duration: 0.1),
            DefaultCommand(key: "l"),
            PauseCommand(duration: 0.1),
            DefaultCommand(key: "o")
        ])
    }

    func testExecutesMultipleKeyPressWithExplicitPause() {
        commandsProcessor!.process("a<p:10><c:a:command>")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            DefaultCommand(key: "a"),
            PauseCommand(duration: 10),
            KeyPressCommand(key: "a", modifiers: ["command"])
        ])
    }

    func testExecutesMultipleKeyPressWithStickyPause() {
        commandsProcessor!.process("ab<P:10>cd")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            DefaultCommand(key: "a"),
            PauseCommand(duration: 0.1),
            DefaultCommand(key: "b"),
            StickyPauseCommand(duration: 10),
            DefaultCommand(key: "c"),
            PauseCommand(duration: 10),
            DefaultCommand(key: "d")
        ])
    }

    func testIgnoreContinuation() {
        commandsProcessor!.process("<\\>")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [])
    }

    func testIgnoreConsecutiveContinuations() {
        commandsProcessor!.process("<\\><\\>")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [])
    }

    func testNegateConsecutiveContinuations() {
        commandsProcessor!.process("<\\><\\>a")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            DefaultCommand(key: "a")
        ])
    }

    func testExecutesMultipleKeyPressWithContinuation() {
        commandsProcessor!.process("a<\\>b")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            DefaultCommand(key: "a")
        ])
    }

    func testExecutesMultipleMouseCommands() {
        commandsProcessor!.process("<m:20,20:1><m:200,200:1><m:left>")
        let commands = commandExecutor!.commands

        XCTAssertEqual(commands, [
            MouseMoveCommand(x1: nil, y1: nil, x2: 20, y2: 20, duration: 1, modifiers: []),
            PauseCommand(duration: 0.1),
            MouseMoveCommand(x1: nil, y1: nil, x2: 200, y2: 200, duration: 1, modifiers: []),
            PauseCommand(duration: 0.1),
            MouseClickCommand(button: "left", modifiers: [], clicks: 1),
        ])
    }
}
