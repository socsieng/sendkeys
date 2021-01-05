import ArgumentParser
import Foundation

enum OutputMode: String, Codable, ExpressibleByArgument {
    case coordinates
    case commands
}

class MousePosition: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Prints the current mouse position."
    )

    @Flag(name: .shortAndLong, help: "Watch and display the mouse positions as the mouse is clicked.")
    var watch = false

    @Option(name: NameSpecification([.customShort("o"), .customLong("output", withSingleDash: false) ]), help: "Displays results as either a series of coordinates or commands.")
    var mode = OutputMode.coordinates

    static let eventProcessor = MouseEventProcessor()

    required init() {
    }

    func run() {
        if watch {
            watchMouseInput()
        } else {
            printMousePosition()
        }
    }

    func printMousePosition() {
        let location = MouseController().getLocation()!
        print(String(format: "%.0f,%.0f", location.x, location.y))
    }

    func listenForInput() {
        fputs("Waiting for user input... Escape or ctrl + d to stop, or any other key to capture mouse position.\n", stderr)

        waitForCharInput { _ in
            printMousePosition()
        }
    }

    func waitForCharInput(callback: (_ char: UInt8) -> Void) {
        let stdIn = FileHandle.standardInput
        let originalTerm = enableRawMode(fileHandle: stdIn)

        var char: UInt8 = 0
        while read(stdIn.fileDescriptor, &char, 1) == 1 {
            if char == 4 /* EOF (Ctrl+D) */ || char == 27 /* escape */ {
                break
            }

            callback(char)
        }

        restoreRawMode(fileHandle: stdIn, originalTerm: originalTerm)
    }

    func watchMouseInput() {
        fputs("Waiting for mouse input... ctrl + c to stop.\n", stderr)

        var eventMask = (1 << CGEventType.leftMouseDown.rawValue)
            | (1 << CGEventType.leftMouseUp.rawValue)
            | (1 << CGEventType.leftMouseDragged.rawValue)
        eventMask = eventMask | (1 << CGEventType.rightMouseDown.rawValue)
            | (1 << CGEventType.rightMouseUp.rawValue)
            | (1 << CGEventType.rightMouseDragged.rawValue)
        eventMask = eventMask | (1 << CGEventType.otherMouseDown.rawValue)
            | (1 << CGEventType.otherMouseUp.rawValue)
            | (1 << CGEventType.otherMouseDragged.rawValue)

        let info = UnsafeMutableRawPointer(mutating: bridge(obj: self))

        guard let eventTap = CGEvent.tapCreate(tap: .cghidEventTap, place: .tailAppendEventTap, options: .defaultTap, eventsOfInterest: CGEventMask(eventMask), callback: {
            (proxy: CGEventTapProxy, eventType: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? in
            let command: MousePosition = bridge(ptr: UnsafeRawPointer(refcon)!)

            if let mouseEvent = MousePosition.eventProcessor.consumeEvent(type: eventType, event: event) {
                switch command.mode {
                case .coordinates:
                    if mouseEvent.eventType == .click {
                        command.printAndFlush(String(format: "%.0f,%.0f", mouseEvent.endPoint.x, mouseEvent.endPoint.y))
                    }
                case .commands:
                    command.printAndFlush(mouseEvent.description)
                }
            }

            return Unmanaged.passRetained(event)
        }, userInfo: info) else {
            MousePosition.exit(withError: RuntimeError("Failed to create event tap."))
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        CFRunLoopRun()
    }

    func printAndFlush(_ message: String) {
        print(message)
        fflush(stdout)
    }

    func eventCallback(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
        switch mode {
        case .coordinates:
            printMousePosition()
        case .commands:
            printMousePosition()
        }
        print("Event \(type) \(type.rawValue)")

        return Unmanaged.passRetained(event)
    }

    // see https://stackoverflow.com/a/24335355/669586
    func initStruct<S>() -> S {
        let struct_pointer = UnsafeMutablePointer<S>.allocate(capacity: 1)
        let struct_memory = struct_pointer.pointee
        struct_pointer.deallocate()
        return struct_memory
    }

    func enableRawMode(fileHandle: FileHandle) -> termios {
        var raw: termios = initStruct()
        tcgetattr(fileHandle.fileDescriptor, &raw)

        let original = raw

        raw.c_lflag &= ~(UInt(ECHO | ICANON))
        tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &raw);

        return original
    }

    func restoreRawMode(fileHandle: FileHandle, originalTerm: termios) {
        var term = originalTerm
        tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &term);
    }
}
