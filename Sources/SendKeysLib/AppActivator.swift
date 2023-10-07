import Cocoa

class AppActivator: NSObject {
    private var application: NSRunningApplication!
    private let appName: String?
    private let processId: Int?

    init(appName: String?, processId: Int?) {
        self.appName = appName?.lowercased()
        self.processId = processId
    }

    func find() throws -> NSRunningApplication? {
        let apps = NSWorkspace.shared.runningApplications.filter({ a in
            return a.activationPolicy == .regular
        })

        var app: NSRunningApplication?

        if processId != nil {
            app =
                apps.filter({ a in
                    return a.processIdentifier == pid_t(processId!)
                }).first

            if app == nil {
                throw RuntimeError(
                    "Application with process id \(processId!) could not be found."
                )
            }
        } else if appName != nil {
            // exact match (case insensitive)
            app =
                apps.filter({ a in
                    return a.localizedName?.lowercased() == appName
                        || a.bundleIdentifier?.lowercased() == appName
                }).first

            let expression = try! NSRegularExpression(
                pattern: "\\b\(NSRegularExpression.escapedPattern(for: appName!))\\b", options: .caseInsensitive)

            // partial name match
            if app == nil {
                app =
                    apps.filter({ a in
                        let nameMatch = expression.firstMatch(
                            in: a.localizedName ?? "", options: [],
                            range: NSMakeRange(0, a.localizedName?.utf16.count ?? 0)
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
        }

        return app
    }

    func activate() throws {
        let app = try! self.find()

        if app == nil && appName != nil {
            throw RuntimeError(
                "Application \(appName!) cannot be activated. Run `sendkeys apps` to see a list of applications that can be activated."
            )
        }

        if app != nil {
            self.application = app

            self.unhideAppIfNeeded()
            self.activateAppIfNeeded()
        }
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
