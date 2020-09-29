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
    // Note: Does not handle decimal values or overflow values
    // Format: PnYnMnDTnHnMnS or PnW
    static func durationFrom8601String(durationString: String) -> DateComponents {
        var durationString = durationString
        var dateComponents = DateComponents()

        guard durationString.contains("P") else {
            logErrorMessage(durationString: durationString)
            return dateComponents
        }

        durationString = durationString.replacingOccurrences(of: "P", with: "")

        if durationString.contains("W") {
            let weekValues = componentsForString(durationString, designatorSet: CharacterSet(charactersIn: "W"))

            if let weekValue = weekValues["W"], let weekValueDouble = Double(weekValue) {
                // 7 day week specified in ISO 8601 standard
                dateComponents.day = Int(weekValueDouble * 7.0)
            }
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
        let periodValues = componentsForString(periodString, designatorSet: CharacterSet(charactersIn: "YMD"))
        dateComponents.day = Int(periodValues["D"] ?? "")
        dateComponents.month = Int(periodValues["M"] ?? "")
        dateComponents.year = Int(periodValues["Y"] ?? "")

        // SnMnHn
        let timeValues = componentsForString(timeString, designatorSet: CharacterSet(charactersIn: "HMS"))
        dateComponents.second = Int(timeValues["S"] ?? "")
        dateComponents.minute = Int(timeValues["M"] ?? "")
        dateComponents.hour = Int(timeValues["H"] ?? "")

        return dateComponents
    }

    private static func componentsForString(_ string: String, designatorSet: CharacterSet) -> [String: String] {
        if string.isEmpty {
            return [:]
        }

        let componentValues = string.components(separatedBy: designatorSet).filter { !$0.isEmpty }
        let designatorValues = string.components(separatedBy: .decimalDigits).filter { !$0.isEmpty }

        guard componentValues.count == designatorValues.count else {
            print("String: \(string) has an invalid format")
            return [:]
        }

        return Dictionary(uniqueKeysWithValues: zip(designatorValues, componentValues))
    }

    private static func logErrorMessage(durationString: String) {
        print("String: \(durationString) has an invalid format")
        print("The durationString must have a format of PnYnMnDTnHnMnS or PnW")
    }
}
