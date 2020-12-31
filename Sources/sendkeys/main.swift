import SendKeysLib
import Foundation

let accessEnabled = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)

if !accessEnabled {
    fputs("\nAccessibility preferences must be enabled to use this tool. If running from the terminal, make sure that your terminal app has accessibility permissiions enabled.\n\n", stderr)
}

if #available(OSX 10.11, *) {
    SendKeysCli.main()
} else {
    print("OS version 10.11 or higher is required.")
}
