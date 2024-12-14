import XCTest

@testable import SendKeysLib

final class KeyPresserTests: XCTestCase {
    func testEscapeKey() throws {
        let presser = KeyPresser(app: nil)
        let event = try! presser.keyPress(key: "escape", modifiers: [])

        XCTAssertEqual(event!.getIntegerValueField(.keyboardEventKeycode), 53)
    }

    func testEscapeKeyUsingAlias() throws {
        let presser = KeyPresser(app: nil)
        let event = try! presser.keyPress(key: "esc", modifiers: [])

        XCTAssertEqual(event!.getIntegerValueField(.keyboardEventKeycode), 53)
    }

    func testEnterKey() throws {
        let presser = KeyPresser(app: nil)
        let event = try! presser.keyPress(key: "return", modifiers: [])

        XCTAssertEqual(event!.getIntegerValueField(.keyboardEventKeycode), 36)
    }

    func testShiftModifier() throws {
        let presser = KeyPresser(app: nil)
        let event = try! presser.keyPress(key: "a", modifiers: ["shift"])

        XCTAssertEqual(event!.getIntegerValueField(.keyboardEventKeycode), 0)
        XCTAssertTrue(event!.flags.contains([.maskShift]))
    }

    func testCommandControlModifier() throws {
        let presser = KeyPresser(app: nil)
        let event = try! presser.keyPress(key: "c", modifiers: ["command", "control"])

        XCTAssertEqual(event!.getIntegerValueField(.keyboardEventKeycode), 8)
        XCTAssertTrue(event!.flags.contains([.maskCommand, .maskControl]))
    }
}
