//
//  TrackerStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 14.07.25.
//
import UIKit
import CoreData

// MARK: - Delegate Protocol

protocol TrackerStoreDelegate: AnyObject {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate)
}

// MARK: - TrackerStore

final class TrackerStore: NSObject {
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try fetchedResultsController.performFetch()
        updateCategories()
    }
    
    // MARK: - Public Methods
    
    func addTracker(_ tracker: Tracker, toCategoryTitle categoryTitle: String) throws {
        
        let categoryEntity: TrackerCategoryCoreData
        
        if let existingCategory = fetchedResultsController.fetchedObjects?.first(where: { $0.title == categoryTitle }) {
            categoryEntity = existingCategory
        } else {
            categoryEntity = TrackerCategoryCoreData(context: context)
            categoryEntity.title = categoryTitle
        }
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.id = tracker.id
        trackerEntity.title = tracker.title
        trackerEntity.colorHex = tracker.color.toHexString()
        trackerEntity.emoji = tracker.emoji
        trackerEntity.schedule = try JSONEncoder().encode(tracker.schedule)
        
        categoryEntity.addToTrackers(trackerEntity)
        
        try context.save()
        try fetchedResultsController.performFetch()
        updateCategories()
        delegate?.store(self, didUpdate: TrackerStoreUpdate(
            insertedIndexes: [],
            deletedIndexes: [],
            updatedIndexes: [],
            movedIndexes: []
        ))
    }
    
    // MARK: - Private Methods
    
    private func updateCategories() {
        categories = fetchedResultsController.fetchedObjects?.map { categoryEntity in
            let trackers = categoryEntity.trackers?.compactMap { trackerObj -> Tracker? in
                guard let trackerEntity = trackerObj as? TrackerCoreData else { return nil }
                return Tracker(
                    id: trackerEntity.id ?? UUID(),
                    title: trackerEntity.title ?? "",
                    color: UIColor(hex: trackerEntity.colorHex ?? "#000000"),
                    emoji: trackerEntity.emoji ?? "",
                    schedule: (try? JSONDecoder().decode([WeekDay].self, from: trackerEntity.schedule ?? Data())) ?? []
                )
            } ?? []
            
            return TrackerCategory(title: categoryEntity.title ?? "", trackers: trackers)
        } ?? []
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? fetchedResultsController.performFetch()
        updateCategories()
        delegate?.store(self, didUpdate: TrackerStoreUpdate(
            insertedIndexes: [],
            deletedIndexes: [],
            updatedIndexes: [],
            movedIndexes: []
        ))
    }
}
