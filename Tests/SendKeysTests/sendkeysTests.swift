import XCTest

import class Foundation.Bundle

final class sendkeysTests: XCTestCase {
    func testHelp() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("sendkeys")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = ["--help"]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertTrue(output!.hasPrefix("OVERVIEW: Command line tool for automating keystrokes and mouse events"))
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
            for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
                return bundle.bundleURL.deletingLastPathComponent()
            }
            fatalError("Couldn't find the products directory\n")
        #else
            return Bundle.main.bundleURL
        #endif
    }
}
