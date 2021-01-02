import Foundation

public protocol CommandExecutorProtocol {
    func execute(_ command: Command)
}

public class CommandExecutor: CommandExecutorProtocol {
    public func execute(_ command: Command) {
        try! command.execute()
    }
}
