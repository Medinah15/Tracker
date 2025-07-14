//
//  PersistenceController.swift
//  Tracker
//
//  Created by Medina Huseynova on 14.07.25.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()
    
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

