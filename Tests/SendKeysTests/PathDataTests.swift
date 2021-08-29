import XCTest

@testable import SendKeysLib

final class PathDataTests: XCTestCase {
    func testNormalizesPathData() throws {
        let result = PathData("M 0 1 L 100 101 H-1V+2 Z").commands
        XCTAssertEqual(
            result,
            [
                PointPathCommand("M", PointValue(CGPoint(x: 0, y: 1))),
                PointPathCommand("L", PointValue(CGPoint(x: 100, y: 101))),
                PointPathCommand("L", PointValue(CGPoint(x: -1, y: 101))),
                PointPathCommand("L", PointValue(CGPoint(x: -1, y: 2))),
                PointPathCommand("L", PointValue(CGPoint(x: 0, y: 1))),
            ]
        )
    }

    func testNormalizesPathDataWithRelativeCommands() throws {
        let result = PathData("m 10 20 h 6 v 10 l 15 -8 c 10 10 20 20 30 30").commands
        XCTAssertEqual(
            result,
            [
                PointPathCommand("M", PointValue(CGPoint(x: 10, y: 20))),
                PointPathCommand("L", PointValue(CGPoint(x: 16, y: 20))),
                PointPathCommand("L", PointValue(CGPoint(x: 16, y: 30))),
                PointPathCommand("L", PointValue(CGPoint(x: 31, y: 22))),
                CubicBezierPathCommand(
                    "C", ControlPointsValue(CGPoint(x: 41, y: 32), CGPoint(x: 51, y: 42), CGPoint(x: 61, y: 52))),
            ]
        )
    }

    func testGetsTotalDistance() throws {
        let result = PathData("M 100 200 l 300 400").getTotalDistance()
        XCTAssertEqual(
            result,
            500
        )
    }

    func testGetsTotalDistanceOfMultipleStraightLines() throws {
        let result = PathData("M 100 200 h 150 v 220").getTotalDistance()
        XCTAssertEqual(
            result,
            370
        )
    }

    func testGetsPointAtInterval_beginning() throws {
        let result = PathData("M 100 200 l 300 400").getPointAtInterval(0)
        XCTAssertEqual(
            result,
            CGPoint(x: 100, y: 200)
        )
    }

    func testGetsPointAtInterval_middle() throws {
        let result = PathData("M 100 200 l 300 400").getPointAtInterval(0.5)
        XCTAssertEqual(
            result,
            CGPoint(x: 250, y: 400)
        )
    }

    func testGetsPointAtInterval_end() throws {
        let result = PathData("M 100 200 l 300 400").getPointAtInterval(1)
        XCTAssertEqual(
            result,
            CGPoint(x: 400, y: 600)
        )
    }

    func testGetsPointAtIntervalOfMultipleStraightLines_middle() throws {
        let result = PathData("M 100 200 h 150 v 220").getPointAtInterval(0.5)
        XCTAssertEqual(
            result,
            CGPoint(x: 250, y: 235)
        )
    }

    func testGetsPointAtIntervalOfMultipleStraightLines_beyond_end() throws {
        let result = PathData("M 100 200 h 150 v 220").getPointAtInterval(1.2)
        XCTAssertEqual(
            result,
            CGPoint(x: 250, y: 420)
        )
    }

    func testGetsPointAtIntervalOfMultipleStraightLinePaths_end() throws {
        let result = PathData("M 100 0 h 20 20 20 l 200 0").getPointAtInterval(1)
        XCTAssertEqual(
            result,
            CGPoint(x: 360, y: 0)
        )
    }

    func testGetsPointAtIntervalOfMultiplePaths_end() throws {
        let result = PathData("M 100 0 a 100,100 0 0,1 200,0 l 100 0").getPointAtInterval(1)
        XCTAssertEqual(
            result,
            CGPoint(x: 400, y: 0)
        )
    }
}
