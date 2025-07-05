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
}
