struct AllConfiguration: Codable {
    var send: SendConfig?
    var mousePosition: MousePositionConfig?
    var transformer: TransformerConfig?

    init(send: SendConfig? = nil, mousePosition: MousePositionConfig? = nil, transformer: TransformerConfig? = nil) {
        self.send = send
        self.mousePosition = mousePosition
        self.transformer = transformer
    }

    func merge(with other: AllConfiguration?) -> AllConfiguration {
        return AllConfiguration(
            send: other?.send?.merge(with: self.send) ?? self.send,
            mousePosition: other?.mousePosition?.merge(with: self.mousePosition) ?? self.mousePosition,
            transformer: other?.transformer?.merge(with: self.transformer) ?? self.transformer
        )
    }
}
