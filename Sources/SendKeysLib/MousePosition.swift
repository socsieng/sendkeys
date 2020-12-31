import ArgumentParser

struct MousePosition: ParsableCommand {
    public static let configuration = CommandConfiguration(
        abstract: "Prints the current mouse position"
    )
    
    mutating func run() {
        let location = MouseController().getLocation()!
        
        print(String(format: "%.0f,%.0f", location.x, location.y))
    }
}
