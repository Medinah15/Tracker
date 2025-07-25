//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 24.07.25.

import UIKit
import CoreData

final class CategoryViewModel {
    
    // MARK: - Public Properties
    
    var categories: [TrackerCategory] = [] {
        didSet {
            onUpdate?(categories)
        }
    }
    
    var selectedCategory: TrackerCategory? {
        didSet {
            onUpdate?(categories)
        }
    }
    
    var selectedCategoryIndex: Int? {
        guard let selectedCategory = selectedCategory else { return nil }
        return categories.firstIndex(where: { $0.title == selectedCategory.title })
    }
    
    var onUpdate: (([TrackerCategory]) -> Void)?
    
    // MARK: - Private Properties
    
    private let categoryStore: TrackerCategoryStore
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        do {
            self.categoryStore = try TrackerCategoryStore(context: context)
            fetchCategories()
        } catch {
            fatalError("Failed to initialize TrackerCategoryStore: \(error)")
        }
    }
    
    // MARK: - Public Methods
    
    func fetchCategories() {
        categories = categoryStore.categories
    }
    
    func selectCategory(at index: Int) {
        guard index < categories.count else { return }
        selectedCategory = categories[index]
        onUpdate?(categories)
    }
    
    func addCategory(title: String) {
        do {
            try categoryStore.addCategory(title: title)
            fetchCategories()
        } catch {
            print("Failed to add category: \(error)")
        }
    }
    
    func deleteCategory(at index: Int) {
        guard index < categories.count else { return }
        let category = categories[index]
        
        do {
            try categoryStore.deleteCategory(title: category.title)
            fetchCategories()
        } catch {
            print("Failed to delete category: \(error)")
        }
    }
    
    func updateCategory(at index: Int, newTitle: String) {
        guard index < categories.count else { return }
        let category = categories[index]
        
        do {
            try categoryStore.updateCategory(oldTitle: category.title, newTitle: newTitle)
            fetchCategories()
        } catch {
            print("Failed to update category: \(error)")
        }
    }
}
