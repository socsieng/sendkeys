import Foundation

class KeyPresser {
    func keyPress(key: String, modifiers: [String]) throws {
        if let keyDownEvent = try! keyDown(key: key, modifiers: modifiers) {
            keyUp(event: keyDownEvent)
        }
    }

    func keyDown(key: String, modifiers: [String]) throws -> CGEvent? {
        let keycode = KeyCodes.getKeyCode(key) ?? 0
        let flags = try! KeyPresser.getModifierFlags(modifiers)
        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: true)
        
        if keycode == 0 {
            if key.count == 1 {
                let utf16Chars = Array(key.utf16)
                keyDownEvent!.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            } else {
                throw RuntimeError("Unrecognized key: \(key)")
            }
        }
        
        if !flags.isEmpty {
            keyDownEvent?.flags = flags
        }

        keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        return keyDownEvent
    }

    func keyUp(event: CGEvent) {
        let keyUpEvent = CGEvent(keyboardEventSource: CGEventSource(event: event), virtualKey: 0, keyDown: false)
        keyUpEvent?.flags = event.flags
        keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
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
