import Foundation
import Yams

struct ConfigLoader {
    static func loadConfig() -> AllConfiguration {
        let defaultConfigFiles = [
            NSString("~/.sendkeysrc.yml").expandingTildeInPath, NSString("~/.sendkeysrc.yaml").expandingTildeInPath,
        ]

        for configFile in defaultConfigFiles {
            if FileManager.default.fileExists(atPath: configFile) {
                if let contents = FileManager.default.contents(atPath: configFile) {
                    do {
                        let decoder = YAMLDecoder()
                        return try decoder.decode(AllConfiguration.self, from: contents)
                    } catch {
                        print("Unable to read \(configFile): \(error)")
                    }
                }
            }
        }

        return AllConfiguration()
    }
}
