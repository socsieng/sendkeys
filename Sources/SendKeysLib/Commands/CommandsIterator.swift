import Foundation

public class CommandsIterator: IteratorProtocol {
    public typealias Element = Command

    let commandString: String
    let commandFactory: CommandFactory

    var index = 0

    public init(_ commandString: String, commandFactory: CommandFactory) {
        self.commandString = commandString
        self.commandFactory = commandFactory
    }

    public func next() -> Element? {
        let length = commandString.utf16.count
        if index < length {
            var matchResult: NSTextCheckingResult?
            if let commandType = CommandFactory.commands.first(where: { (commandType: Command.Type) -> Bool in
                matchResult = commandType.expression.firstMatch(
                    in: commandString, options: .anchored, range: NSMakeRange(index, length - index))
                return matchResult != nil
            }
            ) {
                let args = getArguments(commandString, matchResult!)
                let command = commandFactory.create(commandType, arguments: args)

                if matchResult != nil {
                    let range = Range(matchResult!.range, in: commandString)
                    index = range!.upperBound.utf16Offset(in: commandString)
                }

                return command
            } else {
                fatalError("Unmatched sequence.\n")
            }
        }
        return nil
    }

    private func getArguments(_ commandString: String, _ matchResult: NSTextCheckingResult) -> [String?] {
        var args: [String?] = []
        let numberOfRanges = matchResult.numberOfRanges

        for i in 0..<numberOfRanges {
            let range = Range(matchResult.range(at: i), in: commandString)
            let arg = range == nil ? nil : String(commandString[range!])
            args.append(arg)
        }

        return args
    }
}
