import ArgumentParser
import Foundation

@available(OSX 10.11, *)
class Transformer: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "transform",
        abstract:
            "Transforms raw text input into application friendly character sequences. Examples include accounting for applications that automatically indent source code and insert closing brackets."
    )

    @Option(name: .shortAndLong, help: "Determines if the application automatically inserts indentation.")
    var indent = true

    @Option(
        name: .shortAndLong,
        help:
            "Specifies which brackets are automatically closed by the application and don't need to be explicitly closed."
    )
    var autoClose = "}])"

    @Option(
        name: NameSpecification([.customShort("f"), .long]),
        help: "File containing keystroke instructions to transform.")
    var inputFile: String?

    @Option(name: .shortAndLong, help: "String of characters to transform.")
    var characters: String?

    public init(indent: Bool, autoClose: String = "}])") {
        self.indent = indent
        self.autoClose = autoClose
    }

    required init() {
    }

    func run() {
        var commandString: String?

        if !(inputFile ?? "").isEmpty {
            if let data = FileManager.default.contents(atPath: inputFile!) {
                commandString = String(data: data, encoding: .utf8)
            } else {
                fatalError("Could not read file \(inputFile!)\n")
            }
        } else if !(characters ?? "").isEmpty {
            commandString = characters
        }

        if !(commandString ?? "").isEmpty {
            fputs(transform(commandString!), stdout)
        } else if !isTty() {
            var data: Data

            repeat {
                data = FileHandle.standardInput.availableData

                if data.count > 0 {
                    commandString = String(data: data, encoding: .utf8)
                    fputs(transform(commandString!), stdout)
                }
            } while data.count > 0
        } else {
            print(SendKeysCli.helpMessage(for: Self.self))
        }
    }

    func transform(_ input: String) -> String {
        var output = input

        if indent {
            let removeIndentExpression = try! NSRegularExpression(pattern: "^[\\t ]+", options: .anchorsMatchLines)
            let range = NSRange(location: 0, length: output.count)
            output = removeIndentExpression.stringByReplacingMatches(
                in: output, options: [], range: range, withTemplate: "")
        }

        if !autoClose.isEmpty {
            let removeBracketExpression = try! NSRegularExpression(
                pattern:
                    "\\n[\\t ]*[\(NSRegularExpression.escapedPattern(for: autoClose).replacingOccurrences(of: "]", with: "\\]"))]+"
            )
            let range = NSRange(location: 0, length: output.count)
            output = removeBracketExpression.stringByReplacingMatches(
                in: output, options: .withoutAnchoringBounds, range: range,
                withTemplate: "<\\\\>\n<c:down><p:0><c:right:command>")
        }

        return output
    }
}
