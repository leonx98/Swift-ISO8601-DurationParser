import XCTest
@testable import Swift_ISO8601_DurationParser

final class Swift_ISO8601_DurationParserTests: XCTestCase {
    func testIndividualYearsParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("P1Y")
        XCTAssertEqual(dateComponents?.year, 1)
    }

    func testIndividualMonthsParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("P2M")
        XCTAssertEqual(dateComponents?.month, 2)
    }

    func testIndividualDaysParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("P3D")
        XCTAssertEqual(dateComponents?.day, 3)
    }

    func testIndividualHoursParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("PT11H")
        XCTAssertEqual(dateComponents?.hour, 11)
    }

    func testIndividualMinutesParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("PT42M")
        XCTAssertEqual(dateComponents?.minute, 42)
    }

    func testIndividualSecondsParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("PT32S")
        XCTAssertEqual(dateComponents?.second, 32)
    }

    func testWeeksParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("P8W")
        XCTAssertEqual(dateComponents?.day, 56)
    }

    func testFullStringParsedCorrectly() {
        let dateComponents = DateComponents.durationFrom8601String("P3Y6M4DT12H30M5S")
        XCTAssertEqual(dateComponents?.year, 3)
        XCTAssertEqual(dateComponents?.month, 6)
        XCTAssertEqual(dateComponents?.day, 4)
        XCTAssertEqual(dateComponents?.hour, 12)
        XCTAssertEqual(dateComponents?.minute, 30)
        XCTAssertEqual(dateComponents?.second, 5)
    }

    func testDurationStringNotStartingWithPReturnsNil() {
        let dateComponents = DateComponents.durationFrom8601String("3Y6M4DT12H30M5S")
        let dateComponents2 = DateComponents.durationFrom8601String("8W")
        XCTAssertNil(dateComponents)
        XCTAssertNil(dateComponents2)
    }
}
