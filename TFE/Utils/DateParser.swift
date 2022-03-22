//
//  DateParser.swift
//  TFE
//
//  Created by martin d'hoedt on 3/22/22.
//

import Foundation

class DateParser {
    private static var sharedParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-ddTHH:mm:ss.AAAAAA"
        return formatter
    }()
    
    static func parse(date: String) -> Date? {
        return sharedParser.date(from: date)
    }
}
