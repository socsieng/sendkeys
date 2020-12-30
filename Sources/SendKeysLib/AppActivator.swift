import Cocoa

class AppActivator: NSObject {
    private var application: NSRunningApplication!
    private let filterName: String

    init(appName: String) {
        filterName = appName
    }

    func activate() throws {
        guard let app = NSWorkspace.shared.runningApplications.filter ({
            return $0.localizedName == self.filterName || $0.bundleIdentifier?.contains(self.filterName) ?? false
        }).first else {
            throw RuntimeError("Application \(self.filterName) not found")
        }

        guard app.activationPolicy != .prohibited else {
            throw RuntimeError("Application \(self.filterName) prohibits activation")
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isHidden" {
            application.removeObserver(self, forKeyPath: "isHidden")
            activateAppIfNeeded()
        } else if keyPath == "isActive" {
            application.removeObserver(self, forKeyPath: "isActive")
        }
    }
}
