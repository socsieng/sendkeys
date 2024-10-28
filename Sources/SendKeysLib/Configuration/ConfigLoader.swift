import Foundation
import Yams

let defaultConfigFiles = [
    NSString("~/.sendkeysrc.yml").expandingTildeInPath,
    NSString("~/.sendkeysrc.yaml").expandingTildeInPath,
]

struct ConfigLoader {
    static func loadConfig(_ file: String? = nil) -> AllConfiguration {
        var config = AllConfiguration()

        let configFiles =
            if file != nil {
                [file!]
            } else {
                defaultConfigFiles
            }

        for configFile in configFiles {
            if !configFile.isEmpty && FileManager.default.fileExists(atPath: configFile) {
                if let contents = FileManager.default.contents(atPath: configFile) {
                    do {
                        let decoder = YAMLDecoder()
                        config = config.merge(with: try decoder.decode(AllConfiguration.self, from: contents))
                    } catch {
                        print("Unable to read \(configFile): \(error)")
                    }
                }
            }
        }

        return config
    }
}
