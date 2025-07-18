//
//  WeekDay.swift
//  Tracker
//
//  Created by Medina Huseynova on 26.06.25.
//

import Foundation

enum WeekDay: String, CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

extension WeekDay {
    static func fromCalendarIndex(_ index: Int) -> WeekDay? {
        switch index {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return nil
        }
    }
    
    var shortTitle: String {
        switch self {
        case .monday:  "Пн"
        case .tuesday:  "Вт"
        case .wednesday:  "Ср"
        case .thursday:  "Чт"
        case .friday:  "Пт"
        case .saturday:  "Сб"
        case .sunday:  "Вс"
        }
    }
}

extension WeekDay {
    var displayName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    var sortIndex: Int {
        switch self {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }
}
