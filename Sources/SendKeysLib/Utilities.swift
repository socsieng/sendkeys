import Foundation

func isTty() -> Bool {
    return isatty(FileHandle.standardInput.fileDescriptor) == 1
}

func getRegexGroups(_ expression: NSRegularExpression, _ input: String) -> [String?]? {
    var groups: [String?] = []
    let matchResult = expression.firstMatch(in: input, options: .anchored, range: NSRange(location: 0, length: input.utf8.count))

    if matchResult == nil {
        return nil
    }

    let numberOfRanges = matchResult!.numberOfRanges

    for i in 0..<numberOfRanges {
        let range = Range(matchResult!.range(at: i), in: input)
        let arg = range == nil ? nil : String(input[range!])
        groups.append(arg)
    }

    return groups
}
