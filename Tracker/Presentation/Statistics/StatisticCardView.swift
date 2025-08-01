//
//  StatisticCardView.swift
//  Tracker
//
//  Created by Medina Huseynova on 01.08.25.
//

import UIKit

final class StatisticCardView: UIView {
    
    private let borderLayer = CAGradientLayer()

    init(title: String, value: Int) {
        super.init(frame: .zero)
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        layer.addSublayer(borderLayer)
        
        let valueLabel = UILabel()
        valueLabel.text = "\(value)"
        valueLabel.font = .boldSystemFont(ofSize: 34)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12,weight: .medium)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
       
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            self.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    override func layoutSubviews() {
            super.layoutSubviews()
            
            borderLayer.frame = bounds
            borderLayer.cornerRadius = 16
            borderLayer.borderWidth = 1
            borderLayer.borderColor = UIColor.clear.cgColor
            borderLayer.masksToBounds = true
            
            borderLayer.colors = [
                UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1).cgColor,  
                UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1).cgColor,
                UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1).cgColor
            ]
            
            borderLayer.startPoint = CGPoint(x: 0, y: 0.5)
            borderLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
