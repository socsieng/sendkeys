struct SendConfig: Codable {
    var activate: Bool?
    var animationInterval: Double?
    var delay: Double?
    var initialDelay: Double?
    var keyboardLayout: KeyMappings.Layouts?
    var remap: [String: String]?
    var targeted: Bool?
    var terminateCommand: String?

    init(
        activate: Bool? = nil, animationInterval: Double? = nil, delay: Double? = nil, initialDelay: Double? = nil,
        keyboardLayout: KeyMappings.Layouts? = nil, remap: [String: String]? = nil, targeted: Bool? = nil,
        terminateCommand: String? = nil
    ) {
        self.activate = activate
        self.animationInterval = animationInterval
        self.delay = delay
        self.initialDelay = initialDelay
        self.keyboardLayout = keyboardLayout
        self.remap = remap
        self.targeted = targeted
        self.terminateCommand = terminateCommand
    }

    func merge(with other: SendConfig?) -> SendConfig {
        return SendConfig(
            activate: other?.activate ?? self.activate,
            animationInterval: other?.animationInterval ?? self.animationInterval,
            delay: other?.delay ?? self.delay,
            initialDelay: other?.initialDelay ?? self.initialDelay,
            keyboardLayout: other?.keyboardLayout ?? self.keyboardLayout,
            remap: other?.remap ?? self.remap,
            targeted: other?.targeted ?? self.targeted,
            terminateCommand: other?.terminateCommand ?? self.terminateCommand
        )
    }
}
