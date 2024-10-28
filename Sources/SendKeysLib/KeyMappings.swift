import ArgumentParser

struct KeyMappings {
    enum Layouts: String, Codable, ExpressibleByArgument {
        case qwerty
        case colemak
        case dvorak
    }

    static let Mappings: [Layouts: [String: String]] = [
        .qwerty: Qwerty,
        .colemak: Colemak,
        .dvorak: Dvorak,
    ]

    static let Qwerty: [String: String] = [:]

    static let Colemak: [String: String] = [
        "q": "q",
        "w": "w",
        "f": "e",
        "p": "r",
        "g": "t",
        "j": "y",
        "l": "u",
        "u": "i",
        "y": "o",
        ";": "p",
        "a": "a",
        "r": "s",
        "s": "d",
        "t": "f",
        "d": "g",
        "h": "h",
        "n": "j",
        "e": "k",
        "i": "l",
        "o": ";",
        "z": "z",
        "x": "x",
        "c": "c",
        "b": "b",
        "k": "n",
        "m": "m",
    ]

    static let Dvorak: [String: String] = [
        "[": "-",
        "]": "=",
        "'": "q",
        ",": "w",
        ".": "e",
        "p": "r",
        "y": "t",
        "f": "y",
        "g": "u",
        "c": "i",
        "r": "o",
        "l": "p",
        "/": "[",
        "=": "]",
        "a": "a",
        "o": "s",
        "e": "d",
        "u": "f",
        "i": "g",
        "d": "h",
        "h": "j",
        "t": "k",
        "n": "l",
        "s": ":",
        "-": "'",
        ";": "z",
        "q": "x",
        "j": "c",
        "k": "v",
        "x": "b",
        "b": "n",
        "m": "m",
        "w": ",",
        "v": ".",
        "z": "/",
    ]
}
