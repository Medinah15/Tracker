//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Medina Huseynova on 01.08.25.
//

import Foundation

final class StatisticsViewModel {
    
    // MARK: - Public Properties
    
    var onDataChanged: (() -> Void)?
    
    private(set) var bestPeriod: Int = 0
    private(set) var idealDays: Int = 0
    private(set) var completedCount: Int = 0
    private(set) var averagePerDay: Int = 0
    
    // MARK: - Private Properties
    
    private let recordStore: TrackerRecordStore
    private let trackerStore: TrackerStore
    
    // MARK: - Init
    
    init(recordStore: TrackerRecordStore, trackerStore: TrackerStore) {
        self.recordStore = recordStore
        self.trackerStore = trackerStore
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatistics), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    // MARK: - Public Methods
    
    @objc func updateStatistics() {
        let records = recordStore.records
        let allTrackers = trackerStore.categories.flatMap { $0.trackers }
        
        completedCount = records.count
        
        let calendar = Calendar.current
        
        let groupedByDate = Dictionary(grouping: records, by: { calendar.startOfDay(for: $0.date) })
        
        if !groupedByDate.isEmpty {
            averagePerDay = groupedByDate.map { $0.value.count }.reduce(0, +) / groupedByDate.count
        } else {
            averagePerDay = 0
        }
        
        idealDays = groupedByDate.filter { _, value in
            Set(value.map { $0.trackerId }) == Set(allTrackers.map { $0.id })
        }.count
        
        bestPeriod = calculateBestPeriod(from: records)
        
        onDataChanged?()
    }
    
    // MARK: - Private Methods
    
    private func calculateBestPeriod(from records: [TrackerRecord]) -> Int {
        let sorted = records.sorted(by: { $0.date < $1.date })
        
        guard !sorted.isEmpty else { return 0 }
        if sorted.count == 1 { return 1 }
        
        var best = 1
        var current = 1
        
        for i in 1..<sorted.count {
            let prev = sorted[i - 1].date
            let next = sorted[i].date
            
            guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: prev) else {
                
                return 0
            }
            
            if Calendar.current.isDate(next, equalTo: nextDay, toGranularity: .day) {
                current += 1
            } else {
                best = max(best, current)
                current = 1
            }
        }
        return max(best, current)
    }
}
