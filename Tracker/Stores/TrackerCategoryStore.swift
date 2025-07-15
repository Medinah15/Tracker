//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 14.07.25.
//
import UIKit
import CoreData

// MARK: - Delegate Protocol

protocol TrackerCategoryStoreDelegate: AnyObject {
    
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate)
}

// MARK: - Store Update Structure

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

// MARK: - TrackerCategoryStore class

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    private var insertedIndexes: IndexSet = []
    private var deletedIndexes: IndexSet = []
    private var updatedIndexes: IndexSet = []
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move> = []
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Initialization
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        try fetchedResultsController.performFetch()
    }
    
    // MARK: - Public API
    
    var categories: [TrackerCategory] {
        fetchedResultsController.fetchedObjects?.map { categoryCoreData in
            let trackersCoreData = categoryCoreData.trackers as? Set<TrackerCoreData> ?? []
            let trackers: [Tracker] = trackersCoreData.compactMap { try? mapToTracker($0) }
            
            return TrackerCategory(title: categoryCoreData.title ?? "", trackers: trackers)
        } ?? []
    }
    
    func addTracker(_ tracker: Tracker, toCategoryTitle categoryTitle: String) throws {
        
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", categoryTitle)
        
        let results = try context.fetch(fetchRequest)
        
        if let categoryCoreData = results.first {
            
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.title = tracker.title
            trackerCoreData.colorHex = tracker.color.toHexString()
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = try JSONEncoder().encode(tracker.schedule)
            
            categoryCoreData.addToTrackers(trackerCoreData)
            
            try context.save()
        } else {
            
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.title = categoryTitle
            
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.id = tracker.id
            trackerCoreData.title = tracker.title
            trackerCoreData.colorHex = tracker.color.toHexString()
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = try JSONEncoder().encode(tracker.schedule)
            
            newCategory.addToTrackers(trackerCoreData)
            
            try context.save()
        }
    }
    
    func categoryCoreData(with title: String) -> TrackerCategoryCoreData? {
        return fetchedResultsController.fetchedObjects?.first(where: { $0.title == title })
    }
    
    // MARK: - Private Helpers
    
    private func mapToTracker(_ coreData: TrackerCoreData) throws -> Tracker {
        return Tracker(
            id: coreData.id ?? UUID(),
            title: coreData.title ?? "",
            color: UIColor(hex: coreData.colorHex ?? "#FFFFFF"),
            emoji: coreData.emoji ?? "",
            schedule: try decodeSchedule(coreData.schedule)
        )
    }
    
    private func decodeSchedule(_ data: Data?) throws -> [WeekDay] {
        guard let data else { return [] }
        return try JSONDecoder().decode([WeekDay].self, from: data)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("TrackerCategoryStore: Did change content")
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes,
            movedIndexes: movedIndexes
        )
        delegate?.store(self, didUpdate: update)
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                insertedIndexes.insert(newIndexPath.item)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes.insert(indexPath.item)
            }
        case .update:
            if let indexPath = indexPath {
                updatedIndexes.insert(indexPath.item)
            }
        case .move:
            if let from = indexPath, let to = newIndexPath {
                movedIndexes.insert(.init(oldIndex: from.item, newIndex: to.item))
            }
        @unknown default:
            break
        }
    }
}
