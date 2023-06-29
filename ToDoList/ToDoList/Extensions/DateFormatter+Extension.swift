//
//  DateFormatter+Extension.swift
//  ToDoList
//
//  Created by Andrey Oleynik on 29.06.2023.
//

import UIKit

extension DateFormatter {
    static let taskDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        return dateFormatter
    }()
}

extension Date {
    static func nextDay() -> Date {
        return Date().addingTimeInterval(3600*24)
    }
}
