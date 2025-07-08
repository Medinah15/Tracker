//
//  TrackerDataStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 26.06.25.
//
import UIKit

final class TrackerDataStore {
    private(set) var categories: [TrackerCategory] = []
    
    init() {
        categories = []
    }
    
    func addTracker(_ tracker: Tracker, toCategoryTitle categoryTitle: String) {
        if let index = categories.firstIndex(where: { $0.title == categoryTitle }) {
            let oldCategory = categories[index]
            let newTrackers = oldCategory.trackers + [tracker]
            let newCategory = TrackerCategory(title: oldCategory.title, trackers: newTrackers)
            var newCategories = categories
            newCategories[index] = newCategory
            categories = newCategories
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            categories.append(newCategory)
        }
    }
}
