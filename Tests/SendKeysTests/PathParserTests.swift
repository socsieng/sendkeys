import XCTest

@testable import SendKeysLib

final class PathParserTests: XCTestCase {
    func testParsesRelativeCommand_m() throws {
        let result = PathParser("m 0 1").parse()
        XCTAssertEqual(
            result,
            [PointPathCommand("m", PointValue(CGPoint(x: 0, y: 1)))]
        )
    }

    func testParsesRelativeCommand_l() throws {
        let result = PathParser("l 0 1").parse()
        XCTAssertEqual(
            result,
            [PointPathCommand("l", PointValue(CGPoint(x: 0, y: 1)))]
        )
    }

    func testParsesRelativeCommand_c() throws {
        let result = PathParser("c 0 1 2 3 4 5").parse()
        XCTAssertEqual(
            result,
            [
                CubicBezierPathCommand(
                    "c", ControlPointsValue(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3), CGPoint(x: 4, y: 5)))
            ]
        )
    }

    func testParsesRelativeCommand_s() throws {
        let result = PathParser("s 0 1 2 3").parse()
        XCTAssertEqual(
            result,
            [CubicBezierPathCommand("s", ControlPointsValue(nil, CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3)))]
        )
    }

    func testParsesRelativeCommand_a() throws {
        let result = PathParser("a 10,11 2 0,1 5,6").parse()
        XCTAssertEqual(
            result,
            [ArcPathCommand("a", ArchCommandValue(CGPoint(x: 10, y: 11), 2, false, true, CGPoint(x: 5, y: 6)))]
        )
    }

    func testParsesRelativeCommand_h() throws {
        let result = PathParser("h 1").parse()
        XCTAssertEqual(
            result,
            [NumericPathCommand("h", 1)]
        )
    }

    func testParsesRelativeCommand_v() throws {
        let result = PathParser("v 1").parse()
        XCTAssertEqual(
            result,
            [NumericPathCommand("v", 1)]
        )
    }

    func testParsesRelativeCommand_t() throws {
        let result = PathParser("t 0 1").parse()
        XCTAssertEqual(
            result,
            [QuadraticBezierPathCommand("t", ControlPointValue(nil, CGPoint(x: 0, y: 1)))]
        )
    }

    func testParsesRelativeCommand_q() throws {
        let result = PathParser("q 0 1 2 3").parse()
        XCTAssertEqual(
            result,
            [QuadraticBezierPathCommand("q", ControlPointValue(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3)))]
        )
    }

    func testParsesAbsoluteCommands() throws {
        let result = PathParser("M 0 1 L 100 101 H-1V+2 A 10.2,11 2 0,1 5,6 Z Q 0 1 2 3 T 2 3 C 0 1 2 3 4 5 S 0 1 2 3")
            .parse()
        XCTAssertEqual(
            result,
            [
                PointPathCommand("M", PointValue(CGPoint(x: 0, y: 1))),
                PointPathCommand("L", PointValue(CGPoint(x: 100, y: 101))),
                NumericPathCommand("H", -1),
                NumericPathCommand("V", 2),
                ArcPathCommand("A", ArchCommandValue(CGPoint(x: 10.2, y: 11), 2, false, true, CGPoint(x: 5, y: 6))),
                PathCommandBase("Z"),
                QuadraticBezierPathCommand("Q", ControlPointValue(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3))),
                QuadraticBezierPathCommand("T", ControlPointValue(nil, CGPoint(x: 2, y: 3))),
                CubicBezierPathCommand(
                    "C", ControlPointsValue(CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3), CGPoint(x: 4, y: 5))),
                CubicBezierPathCommand("S", ControlPointsValue(nil, CGPoint(x: 0, y: 1), CGPoint(x: 2, y: 3))),
            ]
        )
    }

    func testParsesAbsoluteCommandsWithAdjacent() throws {
        let result = PathParser("M 0 1 L 200 201 -100 -101 V2,3").parse()
        XCTAssertEqual(
            result,
            [
                PointPathCommand("M", PointValue(CGPoint(x: 0, y: 1))),
                PointPathCommand("L", PointValue(CGPoint(x: 200, y: 201))),
                PointPathCommand("L", PointValue(CGPoint(x: -100, y: -101))),
                NumericPathCommand("V", 2),
                NumericPathCommand("V", 3),
            ]
        )
    }
}
