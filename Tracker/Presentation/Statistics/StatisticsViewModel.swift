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
    
    // MARK: - Private
    private let recordStore: TrackerRecordStore
    private let trackerStore: TrackerStore
    
    init(recordStore: TrackerRecordStore, trackerStore: TrackerStore) {
        self.recordStore = recordStore
        self.trackerStore = trackerStore
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateStatistics), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func updateStatistics() {
        let records = recordStore.records
        let allTrackers = trackerStore.categories.flatMap { $0.trackers }
        
        completedCount = records.count
        
        let calendar = Calendar.current
        
        // 1. Group by date
        let groupedByDate = Dictionary(grouping: records, by: { calendar.startOfDay(for: $0.date) })
        
        // 2. Average per day
        if !groupedByDate.isEmpty {
            averagePerDay = groupedByDate.map { $0.value.count }.reduce(0, +) / groupedByDate.count
        } else {
            averagePerDay = 0
        }
        
        // 3. Ideal days — когда выполнены все активные трекеры
        idealDays = groupedByDate.filter { _, value in
            Set(value.map { $0.trackerId }) == Set(allTrackers.map { $0.id })
        }.count
        
        // 4. Best period — максимальный стрик
        bestPeriod = calculateBestPeriod(from: records)
        
        onDataChanged?()
        
        print("🔁 Updating statistics...")
        print("Records count: \(records.count)")

    }
    
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
                // Невозможно вычислить следующий день - завершение
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

