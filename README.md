# Swift/ISO8601-Duration Parser
Swift 5 extension which converts ISO 8601 duration strings into a `DateComponents` object.

## Examples
PT12H = 12 hours<br>
P3D = 3 days<br>
P3DT12H = 3 days, 12 hours<br>
P3Y6M4DT12H30M5S = 3 years, 6 months, 4 days, 12 hours, 30 minutes and 5 seconds<br>
P10W = 70 days<br>
For more information look here: https://en.wikipedia.org/wiki/ISO_8601#Durations

## Usage
```swift
let durationString = "P3Y6M4DT12H30M5S"
let components = DateComponents.durationFrom8601String(durationString)
components?.year // 3
components?.month // 6
components?.day // 4
components?.hour // 12
components?.minute // 30
components?.second // 5

let durationStringInWeeks = "P8W"
let componentsForWeeks = DateComponents.durationFrom8601String(durationStringInWeeks)
componentsForWeeks?.day //56
```

## Installation

### SPM
You can use [SPM](https://github.com/apple/swift-package-manager). Add the following to your `Package.swift`.

```swift
.package(url: "https://github.com/leonx98/Swift-ISO8601-DurationParser.git", .upToNextMajor(from: "0.9.0")),
```

## Donation

If you like my open source libraries, you can sponsor it! ☺️

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/leonx98)

## License
Swift/ISO8601-Duration Parser is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments
Objective-C version from @kevinrandrup
