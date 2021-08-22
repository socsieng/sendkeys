import Cocoa

class AppActivator: NSObject {
    private var application: NSRunningApplication!
    private let filterName: String

    init(appName: String) {
        filterName = appName.lowercased()
    }

    func activate() throws {
        let apps = NSWorkspace.shared.runningApplications.filter({ a in
            return a.activationPolicy == .regular
        })

        // exact match (case insensitive)
        var app = apps.filter({ a in
            return a.localizedName?.lowercased() == self.filterName
                || a.bundleIdentifier?.lowercased() == self.filterName
        }).first

        let expression = try! NSRegularExpression(
            pattern: "\\b\(NSRegularExpression.escapedPattern(for: self.filterName))\\b", options: .caseInsensitive)

        // partial name match
        if app == nil {
            app =
                apps.filter({ a in
                    let nameMatch = expression.firstMatch(
                        in: a.localizedName ?? "", options: [], range: NSMakeRange(0, a.localizedName?.utf16.count ?? 0)
                    )
                    return nameMatch != nil
                }).first
        }

        // patial bundle id match
        if app == nil {
            app =
                apps.filter({ a in
                    let bundleMatch = expression.firstMatch(
                        in: a.bundleIdentifier ?? "", options: [],
                        range: NSMakeRange(0, a.bundleIdentifier?.utf16.count ?? 0))
                    return bundleMatch != nil
                }).first
        }

        if app == nil {
            throw RuntimeError(
                "Application \(self.filterName) could not be activated. Run `sendkeys apps` to see a list of applications that can be activated."
            )
        }

        self.application = app

        self.unhideAppIfNeeded()
        self.activateAppIfNeeded()
    }

    private func unhideAppIfNeeded() {
        if application.isHidden {
            application.addObserver(self, forKeyPath: "isHidden", options: .new, context: nil)
            application.unhide()
        }
    }

    private func activateAppIfNeeded() {
        if !application.isHidden && !application.isActive {
            application.addObserver(self, forKeyPath: "isActive", options: .new, context: nil)
            application.activate(options: .activateIgnoringOtherApps)
        }
    }

    override func observeValue(
        forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == "isHidden" {
            application.removeObserver(self, forKeyPath: "isHidden")
            activateAppIfNeeded()
        } else if keyPath == "isActive" {
            application.removeObserver(self, forKeyPath: "isActive")
        }
    }
}
