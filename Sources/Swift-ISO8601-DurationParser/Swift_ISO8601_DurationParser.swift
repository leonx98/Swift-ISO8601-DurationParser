//
//  The MIT License (MIT)
//
//  Copyright (c) 2018 Leon Hoppe
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

/*
 * This extension converts ISO 8601 duration strings with the format: P[n]Y[n]M[n]DT[n]H[n]M[n]S or P[n]W into date components
 * Examples:
 * PT12H = 12 hours
 * P3D = 3 days
 * P3DT12H = 3 days, 12 hours
 * P3Y6M4DT12H30M5S = 3 years, 6 months, 4 days, 12 hours, 30 minutes and 5 seconds
 * P10W = 70 days
 * For more information look here: http://en.wikipedia.org/wiki/ISO_8601#Durations
 */

public extension DateComponents {
    static func durationFrom8601String(_ durationString: String) -> DateComponents? {
        try? Self.from8601String(durationString)
    }

    // Note: Does not handle fractional values for months
    // Format: PnYnMnDTnHnMnS or PnW
    static func from8601String(_ durationString: String) throws -> DateComponents {
        guard durationString.starts(with: "P") else {
            throw DurationParsingError.invalidFormat(durationString)
        }

        let durationString = String(durationString.dropFirst())
        var dateComponents = DateComponents()

        if let week = componentFor("W", in: durationString) {
            // 7 day week specified in ISO 8601 standard
            dateComponents.day = Int(week * 7.0)
            return dateComponents
        }

        let tRange = (durationString as NSString).range(of: "T", options: .literal)
        let periodString: String
        let timeString: String
        if tRange.location == NSNotFound {
            periodString = durationString
            timeString = ""
        } else {
            periodString = (durationString as NSString).substring(to: tRange.location)
            timeString = (durationString as NSString).substring(from: tRange.location + 1)
        }

        // DnMnYn
        let year = componentFor("Y", in: periodString)
        let month = componentFor("M", in: periodString).addingFractionsFrom(year, multiplier: 12)
        let day = componentFor("D", in: periodString)

        if let monthFraction = month?.truncatingRemainder(dividingBy: 1),
            monthFraction != 0 {
            // Representing fractional months isn't supported by DateComponents, so we don't allow it here
            throw DurationParsingError.unsupportedFractionsForMonth(durationString)
        }

        dateComponents.year = year?.nonFractionParts
        dateComponents.month = month?.nonFractionParts
        dateComponents.day = day?.nonFractionParts

        // SnMnHn
        let hour = componentFor("H", in: timeString).addingFractionsFrom(day, multiplier: 24)
        let minute = componentFor("M", in: timeString).addingFractionsFrom(hour, multiplier: 60)
        let second = componentFor("S", in: timeString).addingFractionsFrom(minute, multiplier: 60)
        dateComponents.hour = hour?.nonFractionParts
        dateComponents.minute = minute?.nonFractionParts
        dateComponents.second = second.map { Int($0.rounded()) }

        return dateComponents
    }

    private static func componentFor(_ designator: String, in string: String) -> Double? {
        // First split by the designator we're interested in, and then split by all separators. This should give us whatever's before our designator, but after the previous one.
        let beforeDesignator = string.components(separatedBy: designator).first?.components(separatedBy: .separators).last
        return beforeDesignator.flatMap { Double($0) }
    }

    enum DurationParsingError: Error {
        case invalidFormat(String)
        case unsupportedFractionsForMonth(String)
    }
}

private extension Optional where Wrapped == Double {
    func addingFractionsFrom(_ other: Double?, multiplier: Double) -> Self {
        guard let other = other else { return self }
        let toAdd = other.truncatingRemainder(dividingBy: 1) * multiplier
        guard let self = self else { return toAdd }
        return self + toAdd
    }
}

private extension Double {
    var nonFractionParts: Int {
        Int(floor(self))
    }
}

private extension CharacterSet {
    static let separators = CharacterSet(charactersIn: "PWTYMDHMS")
}

extension DateComponents.DurationParsingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidFormat(let durationString):
            return "\(durationString) has an invalid format, The durationString must have a format of PnYnMnDTnHnMnS or PnW"
        case .unsupportedFractionsForMonth(let durationString):
            return "\(durationString) has an invalid format, fractions aren't supported for the month-position"
        }
    }
}
