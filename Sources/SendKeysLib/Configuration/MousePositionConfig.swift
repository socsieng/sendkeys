struct MousePositionConfig: Codable {
    var watch: Bool?
    var output: OutputMode?
    var duration: Double?

    init(watch: Bool? = nil, output: OutputMode? = nil, duration: Double? = nil) {
        self.watch = watch
        self.output = output
        self.duration = duration
    }

    func merge(with other: MousePositionConfig?) -> MousePositionConfig {
        return MousePositionConfig(
            watch: other?.watch ?? self.watch,
            output: other?.output ?? self.output,
            duration: other?.duration ?? self.duration
        )
    }
}
