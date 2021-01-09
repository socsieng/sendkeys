import Foundation

class KeyPresser {
    func keyPress(key: String, modifiers: [String]) throws {
        if let keyDownEvent = try! keyDown(key: key, modifiers: modifiers) {
            let _ = keyUp(event: keyDownEvent)
        }
    }

    func keyDown(key: String, modifiers: [String]) throws -> CGEvent? {
        let keyDownEvent = try! createKeyEvent(key: key, modifiers: modifiers, keyDown: true)

        keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        return keyDownEvent
    }

    func keyUp(key: String, modifiers: [String]) throws -> CGEvent? {
        let keyUpEvent = try! createKeyEvent(key: key, modifiers: modifiers, keyDown: false)

        keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        return keyUpEvent
    }

    func keyUp(event: CGEvent) -> CGEvent? {
        let keyCode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
        let keyUpEvent = CGEvent(keyboardEventSource: CGEventSource(event: event), virtualKey: keyCode, keyDown: false)
        keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        return keyUpEvent
    }

    private func createKeyEvent(key: String, modifiers: [String], keyDown: Bool) throws -> CGEvent? {
        let keycode = KeyCodes.getKeyCode(key)
        let flags = try! KeyPresser.getModifierFlags(modifiers)
        let keyEvent = CGEvent(keyboardEventSource: nil, virtualKey: keycode ?? 0, keyDown: keyDown)

        if keycode == nil {
            if key.count == 1 {
                let utf16Chars = Array(key.utf16)
                keyEvent!.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            } else {
                throw RuntimeError("Unrecognized key: \(key)")
            }
        }

        if !modifiers.isEmpty {
            keyEvent?.flags = flags
        }

        return keyEvent
    }

    static func getModifierFlags(_ modifiers: [String]) throws -> CGEventFlags {
        var flags: CGEventFlags = []

        for modifier in modifiers.filter({ !$0.isEmpty }) {
            let flag = try getModifierFlag(modifier)
            flags.insert(flag)
        }

        return flags
    }

    private static func getModifierFlag(_ modifier: String) throws -> CGEventFlags {
        switch modifier {
        case "⌘",
            "cmd",
            "command":
            return CGEventFlags.maskCommand
        case "^",
            "ctrl",
            "control":
            return CGEventFlags.maskControl
        case "⌥",
            "alt",
            "option":
            return CGEventFlags.maskAlternate
        case "⇧",
            "shift":
            return CGEventFlags.maskShift
        default:
            throw RuntimeError("Unrecognized modifier: \(modifier)")
        }
    }
}
