//
//  DateParser.swift
//  TFE
//
//  Created by martin d'hoedt on 3/22/22.
//

import Foundation

class DateParser {
    
    private static let locale = Locale(identifier: "en_GB")
    
    private static var sharedStringParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSS"
        return formatter
    }()
    
    private static var sharedDateParser: DateFormatter = {
        let formatter = DateFormatter()
        let template = "dMyyyyHH:mm:ss"
        let custom = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        formatter.dateFormat = custom
        return formatter
    }()
    
    private static var sharedShortDateParser: DateFormatter = {
        let formatter = DateFormatter()
        let template = "dMyyyy"
        let custom = DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: locale)
        formatter.dateFormat = custom
        return formatter
    }()
    
    static func stringToDate(dateString: String) -> Date? {
        return sharedStringParser.date(from: dateString)
    }
    
    static func dateToString(date: Date) -> String {
        return sharedDateParser.string(from: date)
    }
    static func dateToShortString(date: Date) -> String {
        return sharedShortDateParser.string(from: date)
    }
    
    static func formatDateString(dateString: String) -> String? {
        guard let date = stringToDate(dateString: dateString) else { return nil }
        return dateToString(date: date)
    }
    static func shortenDateString(dateString: String) -> String? {
        guard let date = stringToDate(dateString: dateString) else { return nil }
        return dateToShortString(date: date)
    }
}
