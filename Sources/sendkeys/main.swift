import Foundation
import SendKeysLib

if #available(OSX 10.11, *) {
    SendKeysCli.main()
} else {
    print("OS version 10.11 or higher is required.")
}
