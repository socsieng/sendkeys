import Foundation

struct Sleeper {
    static func sleep(seconds: Double) {
        usleep(useconds_t(seconds * 1000000))
    }
}
