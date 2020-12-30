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
            Command(.keyPress, ["a"])
        ])
    }
    
    func testExecutesSpecialKeyPress() {
        commandsProcessor!.process("<c:tab>")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.keyPress, ["tab"])
        ])
    }
    
    func testExecutesSpecialKeyPressWithModifier() {
        commandsProcessor!.process("<c:tab:shift>")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.keyPress, ["tab", "shift"])
        ])
    }

    func testExecutesMultipleKeyPressWithDelay() {
        commandsProcessor!.process("hello")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.keyPress, ["h"]),
            Command(.pause, ["0.1"]),
            Command(.keyPress, ["e"]),
            Command(.pause, ["0.1"]),
            Command(.keyPress, ["l"]),
            Command(.pause, ["0.1"]),
            Command(.keyPress, ["l"]),
            Command(.pause, ["0.1"]),
            Command(.keyPress, ["o"])
        ])
    }
    
    func testExecutesMultipleKeyPressWithExplicitPause() {
        commandsProcessor!.process("a<p:10><c:a:command>")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.keyPress, ["a"]),
            Command(.pause, ["10"]),
            Command(.keyPress, ["a", "command"])
        ])
    }
    
    func testExecutesMultipleKeyPressWithStickyPause() {
        commandsProcessor!.process("ab<P:10>cd")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.keyPress, ["a"]),
            Command(.pause, ["0.1"]),
            Command(.keyPress, ["b"]),
            Command(.stickyPause, ["10"]),
            Command(.keyPress, ["c"]),
            Command(.pause, ["10"]),
            Command(.keyPress, ["d"])
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
            Command(.keyPress, ["a"])
        ])
    }

    func testExecutesMultipleKeyPressWithContinuation() {
        commandsProcessor!.process("a<\\>b")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.keyPress, ["a"])
        ])
    }

    func testExecutesMultipleMouseCommands() {
        commandsProcessor!.process("<m:20,20:1><m:200,200:1><m:left>")
        let commands = commandExecutor!.commands
        
        XCTAssertEqual(commands, [
            Command(.mouseMove, ["-1", "-1", "20", "20", "1"]),
            Command(.pause, ["0.1"]),
            Command(.mouseMove, ["-1", "-1", "200", "200", "1"]),
            Command(.pause, ["0.1"]),
            Command(.mouseClick, ["left", "1"]),
        ])
    }
}
