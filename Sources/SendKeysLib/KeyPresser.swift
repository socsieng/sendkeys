import Carbon
import Cocoa
import Foundation

public class KeyPresser {
    private var application: NSRunningApplication?

    init(app: NSRunningApplication?) {
        self.application = app
    }

    func keyPress(key: String, modifiers: [String]) throws -> CGEvent? {
        if let keyDownEvent = try! keyDown(key: key, modifiers: modifiers) {
            return keyUp(key: key, modifiers: modifiers, event: keyDownEvent)
        }

        return nil
    }

    func keyDown(key: String, modifiers: [String]) throws -> CGEvent? {
        let keyDownEvent = try! createKeyEvent(key: key, modifiers: modifiers, keyDown: true)

        if self.application == nil {
            keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            if #available(OSX 10.11, *) {
                keyDownEvent?.postToPid(self.application!.processIdentifier)
            } else {
                keyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            }
        }

        return keyDownEvent
    }

    func keyUp(key: String, modifiers: [String]) throws -> CGEvent? {
        let keyUpEvent = try! createKeyEvent(key: key, modifiers: modifiers, keyDown: false)

        if self.application == nil {
            keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            if #available(OSX 10.11, *) {
                keyUpEvent?.postToPid(self.application!.processIdentifier)
            } else {
                keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            }
        }

        return keyUpEvent
    }

    func keyUp(key: String, modifiers: [String], event: CGEvent) -> CGEvent? {
        let keyUpEvent = try! createKeyEvent(
            key: key, modifiers: modifiers, keyDown: false, parentEventSource: CGEventSource(event: event))

        if self.application == nil {
            keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
        } else {
            if #available(OSX 10.11, *) {
                keyUpEvent?.postToPid(self.application!.processIdentifier)
            } else {
                keyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            }
        }

        return keyUpEvent
    }

    private func createKeyEvent(
        key: String, modifiers: [String], keyDown: Bool, parentEventSource: CGEventSource? = nil
    ) throws -> CGEvent? {
        let info = KeyCodes.getKeyInfo(key)
        let flags = try! KeyPresser.getModifierFlags(modifiers)
        let mergedFlags = flags.union(CGEventFlags(info?.flags ?? []))
        let eventSource = parentEventSource ?? CGEventSource(stateID: .hidSystemState)
        let keyEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: info?.keyCode ?? 0, keyDown: keyDown)

        if info == nil {
            if key.count == 1 {
                let utf16Chars = Array(key.utf16)
                keyEvent!.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
            } else {
                throw RuntimeError("Unrecognized key: \(key)")
            }
        }

        if !mergedFlags.isEmpty {
            keyEvent?.flags = mergedFlags
        } else {
            keyEvent?.flags = []
        }

        return keyEvent
    }

    static func setKeyboardLayout(_ layout: KeyMappings.Layouts) {
        KeyCodes.updateMapping(KeyMappings.Mappings[layout]!)
    }

    static func getModifierFlags(_ modifiers: [String]) throws -> CGEventFlags {
        var flags: CGEventFlags = []

        for modifier in modifiers.filter({ !$0.isEmpty }) {
            let flag = try getModifierFlag(modifier)
            flags.insert(flag)
        }

        return flags
    }

    static func getModifierFlag(_ modifier: String) throws -> CGEventFlags {
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
        case "fn",
            "function":
            return CGEventFlags.maskSecondaryFn
        default:
            throw RuntimeError("Unrecognized modifier: \(modifier)")
        }
    }
}
