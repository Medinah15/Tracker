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
        case .monday: return NSLocalizedString("weekday.short.mon", comment: "Short title for Monday")
        case .tuesday: return NSLocalizedString("weekday.short.tue", comment: "Short title for Tuesday")
        case .wednesday: return NSLocalizedString("weekday.short.wed", comment: "Short title for Wednesday")
        case .thursday: return NSLocalizedString("weekday.short.thu", comment: "Short title for Thursday")
        case .friday: return NSLocalizedString("weekday.short.fri", comment: "Short title for Friday")
        case .saturday: return NSLocalizedString("weekday.short.sat", comment: "Short title for Saturday")
        case .sunday: return NSLocalizedString("weekday.short.sun", comment: "Short title for Sunday")
        }
    }
}

extension WeekDay {
    var displayName: String {
        switch self {
        case .monday: return NSLocalizedString("weekday.full.mon", comment: "Full name of Monday")
        case .tuesday: return NSLocalizedString("weekday.full.tue", comment: "Full name of Tuesday")
        case .wednesday: return NSLocalizedString("weekday.full.wed", comment: "Full name of Wednesday")
        case .thursday: return NSLocalizedString("weekday.full.thu", comment: "Full name of Thursday")
        case .friday: return NSLocalizedString("weekday.full.fri", comment: "Full name of Friday")
        case .saturday: return NSLocalizedString("weekday.full.sat", comment: "Full name of Saturday")
        case .sunday: return NSLocalizedString("weekday.full.sun", comment: "Full name of Sunday")
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
