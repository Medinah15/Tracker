//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Medina Huseynova on 24.07.25.
//

import UIKit

// MARK: - CategoryTableViewCell

final class CategoryTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var viewModel: CategoryCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            titleLabel.text = vm.title
            contentView.backgroundColor = vm.backgroundColor
            accessoryType = vm.isSelected ? .checkmark : .none
        }
    }
    
    // MARK: - Private Properties
    
    private let titleLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        selectionStyle = .none
    }
}
