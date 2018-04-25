# Swift/ISO8601-DurationConverter
Extension which converts ISO 8601 duration strings into a ‘DateComponents‘ object

This extension converts ISO 8601 duration strings with the format: P[n]Y[n]M[n]DT[n]H[n]M[n]S or P[n]W into a 'DateComponents' object.

Examples:
PT12H = 12 hours
P3D = 3 days
P3DT12H = 3 days, 12 hours
P3Y6M4DT12H30M5S = 3 years, 6 months, 4 days, 12 hours, 30 minutes and 5 seconds
P10W = 70 days
For more information look here: http://en.wikipedia.org/wiki/ISO_8601#Durations
