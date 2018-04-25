//
//  ISO8601-DurationParser.swift
//  ISO8601-DurationParser
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

extension DateComponents {
    //Note: Does not handle decimal values or overflow values
    //Format: PnYnMnDTnHnMnS or PnW
    static func durationFrom8601String(durationString: String) -> DateComponents {
        let timeDesignator = CharacterSet(charactersIn:"HMS")
        let periodDesignator = CharacterSet(charactersIn:"YMD")
        
        var dateComponents = DateComponents()
        let mutableDurationString = durationString.mutableCopy() as! NSMutableString
        
        let pRange = mutableDurationString.range(of: "P")
        if pRange.location == NSNotFound {
            self.logErrorMessage(durationString: durationString)
            return dateComponents;
        } else {
            mutableDurationString.deleteCharacters(in: pRange)
        }
        
        
        if (durationString.range(of: "W") != nil) {
            var weekValues = componentsForString(string: mutableDurationString as String, designatorSet: CharacterSet(charactersIn: "W"))
            let weekValue: NSString? = weekValues["W"]! as NSString
            
            if (weekValue != nil) {
                 //7 day week specified in ISO 8601 standard
                dateComponents.day = Int(weekValue!.doubleValue * 7.0)
            }
            return dateComponents
        }
        
        let tRange = mutableDurationString.range(of: "T", options: .literal)
        var periodString = ""
        var timeString = ""
        if tRange.location == NSNotFound {
            periodString = mutableDurationString as String
            
        } else {
            periodString = mutableDurationString.substring(to: tRange.location)
            timeString = mutableDurationString.substring(from: tRange.location + 1)
        }
        
        //DnMnYn
        let periodValues = componentsForString(string: periodString, designatorSet: periodDesignator)
        for (key, obj) in periodValues {
            let value = (obj as NSString).integerValue
            if key == "D" {
                dateComponents.day = value
            } else if key == "M" {
                dateComponents.month = value
            } else if key == "Y" {
                dateComponents.year = value
            }
        }
        
        //SnMnHn
        let timeValues = componentsForString(string: timeString, designatorSet: timeDesignator)
        for (key, obj) in timeValues {
            let value = (obj as NSString).integerValue
            if key == "S" {
                dateComponents.second = value
            } else if key == "M" {
                dateComponents.minute = value
            } else if key == "H" {
                dateComponents.hour = value
            }
        }
        
        return dateComponents
    }
    
    static func componentsForString(string: String, designatorSet: CharacterSet) -> Dictionary<String, String> {
        if string.count == 0 {
            return Dictionary()
        }
        let numericalSet = NSCharacterSet.decimalDigits
        let componentValues = (string.components(separatedBy: designatorSet as CharacterSet) as NSArray).mutableCopy() as! NSMutableArray
        let designatorValues = (string.components(separatedBy: numericalSet) as NSArray).mutableCopy() as! NSMutableArray
        componentValues.remove("")
        designatorValues.remove("")
        if componentValues.count == designatorValues.count {
            var dictionary = Dictionary<String, String>(minimumCapacity: componentValues.count)
            for i in 0...componentValues.count - 1 {
                let key = designatorValues[i] as! String
                let value = componentValues[i] as! String
                dictionary[key] = value
            }
            return dictionary
        } else {
            print("String: \(string) has an invalid format")
        }
        return Dictionary()
    }
    
    static func logErrorMessage(durationString: String) {
        print("String: \(durationString) has an invalid format")
        print("The durationString must have a format of PnYnMnDTnHnMnS or PnW")
    }
}
