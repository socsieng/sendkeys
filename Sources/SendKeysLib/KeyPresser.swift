import Foundation

class KeyPresser {
    func pressKey(key: String, modifiers: [String]) throws {
        let keycode = KeyCodes.getKeyCode(key) ?? 0
        
        var flags: CGEventFlags = []
        for modifier in modifiers {
            let flag = try getModifierFlag(modifier)
            flags.insert(flag)
        }

        let keyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: true)
        
        if keycode == 0 {
            if key.count == 1 {
                let utf16Chars = Array(key.utf16)
                keyDownEvent!.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            } else {
                throw RuntimeError("Unrecognized key: \(key)")
            }
        }
        
        keyDownEvent!.flags = flags
        keyDownEvent!.post(tap: CGEventTapLocation.cghidEventTap)

        let keyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: keycode, keyDown: false)
        keyUpEvent!.flags = flags
        keyUpEvent!.post(tap: CGEventTapLocation.cghidEventTap)
    }
    
    private func getModifierFlag(_ modifier: String) throws -> CGEventFlags {
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
