//
//  CategoryCellViewModel.swift
//  Tracker
//
//  Created by Medina Huseynova on 24.07.25.
//

import UIKit

final class CategoryCellViewModel {
    
    // MARK: - Public Properties
    
    let title: String
    let backgroundColor: UIColor
    let isSelected: Bool
    
    var titleBinding: ((String) -> Void)?
    var backgroundColorBinding: ((UIColor) -> Void)?
    var accessoryTypeBinding: ((UITableViewCell.AccessoryType) -> Void)?
    
    // MARK: - Init
    
    init(title: String, backgroundColor: UIColor, isSelected: Bool) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.isSelected = isSelected
    }
    
    // MARK: - Public Methods
    
    func bind() {
        titleBinding?(title)
        backgroundColorBinding?(backgroundColor)
        accessoryTypeBinding?(isSelected ? .checkmark : .none)
    }
}
