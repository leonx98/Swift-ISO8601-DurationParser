import XCTest
@testable import Swift_ISO8601_DurationParser

final class Swift_ISO8601_DurationParserTests: XCTestCase {
    func testIndividualYearsParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("P1Y")
        XCTAssertEqual(dateComponents.year, 1)
    }

    func testIndividualMonthsParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("P2M")
        XCTAssertEqual(dateComponents.month, 2)
    }

    func testIndividualDaysParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("P3D")
        XCTAssertEqual(dateComponents.day, 3)
    }

    func testIndividualHoursParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("PT11H")
        XCTAssertEqual(dateComponents.hour, 11)
    }

    func testIndividualMinutesParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("PT42M")
        XCTAssertEqual(dateComponents.minute, 42)
    }

    func testIndividualSecondsParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("PT32S")
        XCTAssertEqual(dateComponents.second, 32)
    }

    func testWeeksParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("P8W")
        XCTAssertEqual(dateComponents.day, 56)
    }

    func testFullStringParsedCorrectly() throws {
        let dateComponents = try DateComponents.from8601String("P3Y6M4DT12H30M5S")
        XCTAssertEqual(dateComponents.year, 3)
        XCTAssertEqual(dateComponents.month, 6)
        XCTAssertEqual(dateComponents.day, 4)
        XCTAssertEqual(dateComponents.hour, 12)
        XCTAssertEqual(dateComponents.minute, 30)
        XCTAssertEqual(dateComponents.second, 5)
    }

    func testDurationStringNotStartingWithPReturnsNil() {
        XCTAssertThrowsError(try DateComponents.from8601String("3Y6M4DT12H30M5S"))
        XCTAssertThrowsError(try DateComponents.from8601String("8W"))
    }

    func testParsingFractionalHours() throws {
        let dateComponents = try DateComponents.from8601String("PT0.5H45S")
        XCTAssertEqual(dateComponents.hour, 0)
        XCTAssertEqual(dateComponents.minute, 30)
        XCTAssertEqual(dateComponents.second, 45)
    }

    func testParsingFractionalMinutesWithCarryOver() throws {
        let dateComponents = try DateComponents.from8601String("PT1.25M10S")
        XCTAssertEqual(dateComponents.minute, 1)
        XCTAssertEqual(dateComponents.second, 25) // 10 seconds + 15 seconds (0.25 minutes * 60 seconds)
    }

    func testParsingFractionalSecondsTruncating() throws {
        let dateComponents = try DateComponents.from8601String("PT42.25S")
        XCTAssertEqual(dateComponents.second, 42)
    }

    func testParsingFractionalSecondsRoundingUp() throws {
        let dateComponents = try DateComponents.from8601String("PT18.6125S")
        XCTAssertEqual(dateComponents.second, 19)
    }
}
