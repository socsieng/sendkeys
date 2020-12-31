import Foundation

public class CommandMatcher {
    let expression: NSRegularExpression
    
    public func createCommand(_ arguments: [String?]) -> Command {
        fatalError("Not implemented\n")
    }
    
    public init(_ expression: NSRegularExpression) {
        self.expression = expression
    }
}
