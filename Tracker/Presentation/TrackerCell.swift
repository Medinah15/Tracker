//
//  TrackerCell.swift
//  Tracker
//
//  Created by Medina Huseynova on 29.06.25.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "TrackerCell"
    var onTap: (() -> Void)?
    
    // MARK: - Private UI Elements
    
    private let backgroundCardView = UIView()
    private let emojiBackgroundView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    private let counterLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(title: String, emoji: String, color: UIColor, isCompleted: Bool, count: Int) {
        backgroundCardView.backgroundColor = color
        emojiBackgroundView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        titleLabel.textColor = .white
        emojiLabel.text = emoji
        titleLabel.text = title
        counterLabel.text = "\(count) дней"
        updateButtonAppearance(isCompleted: isCompleted, color: color)
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        contentView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        backgroundCardView.layer.cornerRadius = 16
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundCardView)
        
        emojiBackgroundView.layer.cornerRadius = 12
        emojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.addSubview(emojiBackgroundView)
        
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.addSubview(emojiLabel)
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.addSubview(titleLabel)
        
        counterLabel.font = .systemFont(ofSize: 12)
        counterLabel.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(counterLabel)
        
        actionButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        actionButton.backgroundColor = .black
        actionButton.layer.cornerRadius = 17
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundCardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiBackgroundView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: 12),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.topAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: 16),
            
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionButton.centerYAnchor.constraint(equalTo: counterLabel.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 34),
            actionButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func updateButtonAppearance(isCompleted: Bool, color: UIColor) {
        let imageName = isCompleted ? "checkmark" : "plus"
        let image = UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 10.62, weight: .bold))
        actionButton.setImage(image, for: .normal)
        actionButton.backgroundColor = color
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        onTap?()
    }
}
