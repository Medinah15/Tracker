//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 14.07.25.
//
import Foundation
import CoreData

// MARK: - Delegate Protocols

protocol TrackerRecordStoreDelegate: AnyObject {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate)
}

// MARK: - Update Info Struct

struct TrackerRecordStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

// MARK: - TrackerRecordStore

final class TrackerRecordStore: NSObject {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
    
    // MARK: - Public Properties
    
    
    weak var delegate: TrackerRecordStoreDelegate?
    private(set) var records: [TrackerRecord] = []
    
    // MARK: - Initialization
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        
        try fetchedResultsController.performFetch()
        updateRecords()
    }
    
    // MARK: - Public Methods
    
    func addRecord(for trackerId: UUID, on date: Date) throws {
        let record = TrackerRecordCoreData(context: context)
        record.trackerId = trackerId
        record.date = date
        
        try context.save()
        try fetchedResultsController.performFetch()
        updateRecords()
        delegate?.store(self, didUpdate: TrackerRecordStoreUpdate(
            insertedIndexes: [],
            deletedIndexes: [],
            updatedIndexes: [],
            movedIndexes: []
        ))
    }
    
    func removeRecord(for trackerId: UUID, on date: Date) throws {
        guard let recordToDelete = fetchedResultsController.fetchedObjects?.first(where: {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date ?? Date(), inSameDayAs: date)
        }) else { return }
        
        context.delete(recordToDelete)
        try context.save()
        try fetchedResultsController.performFetch()
        updateRecords()
        delegate?.store(self, didUpdate: TrackerRecordStoreUpdate(
            insertedIndexes: [],
            deletedIndexes: [],
            updatedIndexes: [],
            movedIndexes: []
        ))
    }
    
    func isCompleted(_ trackerId: UUID, on date: Date) -> Bool {
        records.contains {
            $0.trackerId == trackerId && Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateRecords() {
        records = fetchedResultsController.fetchedObjects?.map {
            TrackerRecord(trackerId: $0.trackerId ?? UUID(), date: $0.date ?? Date())
        } ?? []
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? fetchedResultsController.performFetch()
        updateRecords()
        delegate?.store(self, didUpdate: TrackerRecordStoreUpdate(
            insertedIndexes: [],
            deletedIndexes: [],
            updatedIndexes: [],
            movedIndexes: []
        ))
    }
}
