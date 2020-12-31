import ArgumentParser
import Foundation

struct MousePosition: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Prints the current mouse position."
    )
    
    @Flag(help: "Wait for user input to diplay the mouse position. Useful for capturing multiple mouse positions.")
    var wait = false
    
    mutating func run() {
        if wait {
            listenForInput()
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
        
        let stdIn = FileHandle.standardInput
        let originalTerm = enableRawMode(fileHandle: stdIn)

        var char: UInt8 = 0
        while read(stdIn.fileDescriptor, &char, 1) == 1 {
            if char == 4 /* EOF (Ctrl+D) */ || char == 27 /* escape */ {
                break
            }
            
            printMousePosition()
        }
        
        restoreRawMode(fileHandle: stdIn, originalTerm: originalTerm)
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
