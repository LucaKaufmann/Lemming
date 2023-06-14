//
//  DateFormatterService.swift
//  Lemming
//
//  Created by Luca Kaufmann on 14.6.2023.
//

import Foundation

struct DateFormatterService {
    let dateFormatter: DateFormatter
    let relativeDateFormatter: RelativeDateTimeFormatter
    
    init() {
        self.relativeDateFormatter = RelativeDateTimeFormatter()
        
        relativeDateFormatter.dateTimeStyle = .numeric
        relativeDateFormatter.unitsStyle = .short
        relativeDateFormatter.formattingContext = .standalone
        relativeDateFormatter.calendar = .autoupdatingCurrent
        
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = .gmt
    }
    
    func relativeDateTimeDescription(for date: Date?) -> String {
        guard let date else {
            return ""
        }
        return relativeDateFormatter.localizedString(for: date, relativeTo: .now)
    }
    
    func date(from dateString: String) -> Date? {
        dateFormatter.date(from: dateString)
    }
}
