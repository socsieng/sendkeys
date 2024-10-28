struct TransformerConfig: Codable {
    var indent: Bool?
    var autoClose: String?

    init(indent: Bool? = nil, autoClose: String? = nil) {
        self.indent = indent
        self.autoClose = autoClose
    }

    func merge(with other: TransformerConfig?) -> TransformerConfig {
        return TransformerConfig(
            indent: other?.indent ?? self.indent,
            autoClose: other?.autoClose ?? self.autoClose
        )
    }
}
