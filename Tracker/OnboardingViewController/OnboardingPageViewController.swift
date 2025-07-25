//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 22.07.25.
//
import UIKit

// MARK: - OnboardingPageViewController

final class OnboardingPageViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let backgroundImageName: String
    private let titleText: String
    
    // MARK: - Public Methods (Init)
    
    init(backgroundImageName: String, titleText: String) {
        self.backgroundImageName = backgroundImageName
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImage()
        setupTitleLabel()
    }
    
    // MARK: - Private Methods
    
    private func setupBackgroundImage() {
        let backgroundImageView = UIImageView(image: UIImage(named: backgroundImageName))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 432),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
        ])
    }
}
