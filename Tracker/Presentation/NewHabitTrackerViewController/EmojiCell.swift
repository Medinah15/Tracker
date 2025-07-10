//
//  EmojiCell.swift
//  Tracker
//
//  Created by Medina Huseynova on 09.07.25.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let reuseIdentifier = "EmojiCell"
    
    // MARK: - Private Properties
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backgroundViewContainer)
        backgroundViewContainer.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            backgroundViewContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backgroundViewContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 52),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 52),
            
            emojiLabel.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with emoji: String, selected: Bool) {
        emojiLabel.text = emoji
        backgroundViewContainer.backgroundColor = selected
        ? UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 0.3)
        : .clear
    }
}
