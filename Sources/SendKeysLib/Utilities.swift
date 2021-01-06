import Foundation

func isTty() -> Bool {
    return isatty(FileHandle.standardInput.fileDescriptor) == 1
}
