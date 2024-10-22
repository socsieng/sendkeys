import Cocoa
import Foundation

class TerminationListener {
    private var keycode: UInt16
    private var modifiers: [CGEventFlags]
    private var callback: () -> Void
    private let flags: [CGEventFlags] = [.maskCommand, .maskControl, .maskShift, .maskAlternate]
    private var runLoopSource: CFRunLoopSource?
    private var runLoop: CFRunLoop?
    private let expression = try! NSRegularExpression(pattern: "^(.|[\\w]+)(:([,\\w⌘^⌥⇧]+))?$")

    init(sequence: String, callback: @escaping () -> Void) {
        guard let groups = getRegexGroups(expression, sequence) else {
            fatalError("Invalid sequence: \(sequence)")
        }
        let modifiers = groups[3]?.split(separator: ",") ?? []

        self.keycode = KeyCodes.getKeyInfo(groups[1]!)!.keyCode
        do {
            self.modifiers = try modifiers.map {
                (modifier) -> CGEventFlags in
                try KeyPresser.getModifierFlag(String(modifier))
            }
        } catch {
            fatalError("Failed to get modifier flags: \(error)")
        }
        self.callback = callback
    }

    func listen() {
        DispatchQueue.global(qos: .background).async {
            self.listenSync()
        }
    }

    private func listenSync() {
        let eventMask = 1 << CGEventType.keyDown.rawValue

        self.runLoop = CFRunLoopGetCurrent()
        let info = UnsafeMutableRawPointer(mutating: bridge(obj: self))

        guard
            let eventTap = CGEvent.tapCreate(
                tap: .cghidEventTap, place: .tailAppendEventTap, options: .defaultTap,
                eventsOfInterest: CGEventMask(eventMask),
                callback: {
                    (proxy: CGEventTapProxy, eventType: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?)
                        -> Unmanaged<CGEvent>? in

                    let listener: TerminationListener = bridge(ptr: UnsafeRawPointer(refcon)!)
                    let keycode = event.getIntegerValueField(.keyboardEventKeycode)

                    if keycode == listener.keycode {
                        var flagsMatch = true
                        for flag in listener.flags {
                            if event.flags.contains(flag) != listener.modifiers.contains(flag) {
                                flagsMatch = false
                                break
                            }
                        }

                        if flagsMatch {
                            listener.callback()
                        }
                    }

                    return Unmanaged.passRetained(event)
                }, userInfo: info)
        else {
            fatalError("Failed to create event tap.")
        }

        self.runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(self.runLoop, runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }

    func stop() {
        guard let runLoopSource = self.runLoopSource else {
            return
        }

        guard let runLoop = self.runLoop else {
            return
        }

        CFRunLoopRemoveSource(runLoop, runLoopSource, .commonModes)
        CFRunLoopStop(runLoop)
    }
}
