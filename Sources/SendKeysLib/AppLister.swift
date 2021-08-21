import ArgumentParser
import Cocoa
import Foundation

class AppLister: ParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "apps",
        abstract:
            "Lists apps that can be used with the send command."
    )

    struct AppInfo: Hashable {
        let name: String?
        let id: String?

        init(name: String?, id: String?) {
            self.name = name
            self.id = id
        }

        static func == (lhs: AppInfo, rhs: AppInfo) -> Bool {
            return lhs.name == rhs.name && lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(self.name)
            hasher.combine(self.id)
        }
    }

    required init() {
    }

    func run() {
        let apps = Set(
            NSWorkspace.shared.runningApplications.filter { app in
                return app.activationPolicy == .regular
            }
            .map { app in
                return AppInfo(name: app.localizedName, id: app.bundleIdentifier)
            }
        )
        .sorted { a, b in
            return a.name?.lowercased() ?? "" < b.name?.lowercased() ?? ""
        }

        let maxLength = apps.reduce(
            0,
            { max, info in
                return info.name?.count ?? 0 > max ? info.name!.count : max
            })

        apps.forEach { info in
            print(
                "\((info.name ?? "-").padding(toLength: maxLength + 4, withPad: " ", startingAt: 0))id:\(info.id ?? "-")"
            )
        }
    }
}
