//
//  TrackerDataStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 26.06.25.
//

import UIKit

// TrackerDataStore.swift
final class TrackerDataStore {
    private(set) var categories: [TrackerCategory] = []

    func add(_ tracker: Tracker, to categoryTitle: String) {
        // добавление трекера в новую категорию
    }

    func getTrackers(for weekday: WeekDay) -> [Tracker] {
        return []
        // возвращает трекеры по расписанию
    }
}

