@testable import SendKeysLib

import XCTest

final class TransformerTests: XCTestCase {
    func testShouldNoteTransformSingleLine() {
        let transformer = Transformer(indent: true)
        let result = transformer.transform("hello world")
        
        XCTAssertEqual(result, "hello world")
    }

    func testShouldNotTransformCurlyBraceOnSameLine() {
        let transformer = Transformer(indent: true)
        let result = transformer.transform("{}")
        
        XCTAssertEqual(result, "{}")
    }

    func testTransformCurlyBraceOnDifferentLine() {
        let transformer = Transformer(indent: true)
        let result = transformer.transform("{\n}")
        
        XCTAssertEqual(result, "{<\\>\n<c:down><p:0><c:right:command>")
    }

    func testTransformCurlyBraceWithBasicContent() {
        let transformer = Transformer(indent: true)
        let result = transformer.transform("hello {\n  world\n}")
        
        XCTAssertEqual(result, "hello {\nworld<\\>\n<c:down><p:0><c:right:command>")
    }

    func testTransformBracketAndCurlyBraceWithBasicContent() {
        let transformer = Transformer(indent: true)
        let result = transformer.transform("hello ({\n  world\n})")
        
        XCTAssertEqual(result, "hello ({\nworld<\\>\n<c:down><p:0><c:right:command>")
    }
}
