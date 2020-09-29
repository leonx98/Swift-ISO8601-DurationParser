import XCTest
@testable import Swift_ISO8601_DurationParser

final class Swift_ISO8601_DurationParserTests: XCTestCase {
    func testIndividualYearsParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "P1Y")
        XCTAssertEqual(dateComponents.year, 1)
    }

    func testIndividualMonthsParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "P2M")
        XCTAssertEqual(dateComponents.month, 2)
    }

    func testIndividualDaysParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "P3D")
        XCTAssertEqual(dateComponents.day, 3)
    }

    func testIndividualHoursParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "PT11H")
        XCTAssertEqual(dateComponents.hour, 11)
    }

    func testIndividualMinutesParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "PT42M")
        XCTAssertEqual(dateComponents.minute, 42)
    }

    func testIndividualSecondsParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "PT32S")
        XCTAssertEqual(dateComponents.second, 32)
    }

    func testWeeksParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "P8W")
        XCTAssertEqual(dateComponents.day, 56)
    }

    func testFullStringParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String(durationString: "P3Y6M4DT12H30M5S")
        XCTAssertEqual(dateComponents.year, 3)
        XCTAssertEqual(dateComponents.month, 6)
        XCTAssertEqual(dateComponents.day, 4)
        XCTAssertEqual(dateComponents.hour, 12)
        XCTAssertEqual(dateComponents.minute, 30)
        XCTAssertEqual(dateComponents.second, 5)
    }
}
