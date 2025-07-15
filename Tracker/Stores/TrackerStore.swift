//
//  TrackerStore.swift
//  Tracker
//
//  Created by Medina Huseynova on 14.07.25.
//
import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate)
}

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

// MARK: - TrackerStore (управление трекерами и категориями)

final class TrackerStore: NSObject {
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    
    // MARK: - Public Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    private(set) var categories: [TrackerCategory] = []
    
    // MARK: - Initialization
    
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

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? fetchedResultsController.performFetch()
        updateCategories()
        // Здесь можно сделать обновление с более детальной информацией
        delegate?.store(self, didUpdate: TrackerStoreUpdate(
            insertedIndexes: [],
            deletedIndexes: [],
            updatedIndexes: [],
            movedIndexes: []
        ))
    }
}

extension UIColor {
    func toHexString() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    convenience init(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
