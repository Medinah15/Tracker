//
//  PersistenceController.swift
//  Tracker
//
//  Created by Medina Huseynova on 14.07.25.
//

import CoreData

final class PersistenceController {
    
    // MARK: - Public properties
    
    static let shared = PersistenceController()
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Private properties
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Unresolved error loading persistent stores: \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    // MARK: - Public methods
    
    func saveContext() throws {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error.localizedDescription)")
                throw error
            }
        }
    }
}
