//
//  TrackerDataStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 26.06.25.
//

import UIKit

final class TrackerDataStore {
    
    // MARK: - Public Properties
    
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Public Methods
    
    func add(_ tracker: Tracker, to categoryTitle: String) {
    }
    
    func getTrackers(for weekday: WeekDay) -> [Tracker] {
        return []
    }
}
