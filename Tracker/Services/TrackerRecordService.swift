//
//  TrackerRecordService.swift
//  Tracker
//
//  Created by Medina Huseynova on 26.06.25.
//
import Foundation

final class TrackerRecordService {
    private(set) var completedTrackers: [TrackerRecord] = []
    
    func addRecord(for trackerId: UUID, on date: Date) {
        completedTrackers.append(TrackerRecord(trackerId: trackerId, date: date))
    }
    
    func removeRecord(for trackerId: UUID, on date: Date) {
        completedTrackers.removeAll {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    func isCompleted(_ trackerId: UUID, on date: Date) -> Bool {
        completedTrackers.contains {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
}
