# Swift/ISO8601-Duration Parser
Swift 5 extension which converts ISO 8601 duration strings into a `DateComponents` object.


### Examples
PT12H = 12 hours <br>
P3D = 3 days <br>
P3DT12H = 3 days, 12 hours <br>
P3Y6M4DT12H30M5S = 3 years, 6 months, 4 days, 12 hours, 30 minutes and 5 seconds <br>
P10W = 70 days <br>
For more information look here: https://en.wikipedia.org/wiki/ISO_8601#Durations

### Usage
```swift
let durationString = "P3Y6M4DT12H30M5S"
let components = DateComponents.durationFrom8601String(durationString)
```
## Donation

If you like my open source libraries, you can sponsor it! ☺️

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/leonx98)

## License
This file is licensed under the MIT License.

## Acknowledgments
Objective-C version from @kevinrandrup
