//
//  FilterType.swift
//  Tracker
//
//  Created by Medina Huseynova on 30.07.25.
//
enum TrackerFilter: Int, CaseIterable {
    case all = 0
    case today
    case completed
    case uncompleted
    
    var title: String {
        switch self {
        case .all: return "Все трекеры"
        case .today: return "Трекеры на сегодня"
        case .completed: return "Завершённые"
        case .uncompleted: return "Незавершённые"
        }
    }
}

