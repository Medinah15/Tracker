//
//  Calendar+FutureCheck.swift
//  Tracker
//
//  Created by Medina Huseynova on 05.07.25.
//

import Foundation

extension Calendar {
    func isDateInFuture(_ date: Date) -> Bool {
        return date > Date().startOfDay
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}


