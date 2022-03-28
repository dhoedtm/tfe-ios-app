//
//  DateParser.swift
//  TFE
//
//  Created by martin d'hoedt on 3/22/22.
//

import Foundation

class DateParser {
    
    private static let fr_BE = Locale(identifier: "fr_BE")
    
    private static var sharedStringParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSS"
        return formatter
    }()
    
    private static var sharedDateParser: DateFormatter = {
        let formatter = DateFormatter()
        let template = "dMyyyyHH:mm:ss"
        let custom = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: fr_BE)
        formatter.dateFormat = custom
        return formatter
    }()
    
    static func stringToDate(date: String) -> Date? {
        return sharedStringParser.date(from: date)
    }
    
    static func dateToString(date: Date) -> String {
        return sharedDateParser.string(from: date)
    }
    
    static func formatDateString(date: String) -> String? {
        guard let date = stringToDate(date: date) else { return nil }
        return dateToString(date: date)
    }
}
