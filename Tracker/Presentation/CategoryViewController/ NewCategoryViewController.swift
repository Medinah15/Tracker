//
//   NewCategoryViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 24.07.25.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onCategoryCreated: ((String) -> Void)?
    
    // MARK: - Private UI Elements
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("newcategory.placeholder", comment: "Placeholder for new category name")
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("newcategory.savebutton", comment: "Title for save button on new category screen"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("newcategory.title", comment: "Title for new category screen")
        
        navigationItem.hidesBackButton = true
        
        setupConstraints()
        setupActions()
    }
    
    // MARK: - Private Methods
    
    private func setupConstraints() {
        view.addSubview(categoryTextField)
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupActions() {
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let hasText = !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        saveButton.isEnabled = hasText
        saveButton.backgroundColor = hasText ? .black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
    
    @objc private func saveButtonTapped() {
        guard let categoryTitle = categoryTextField.text?.trimmingCharacters(in: .whitespaces), !categoryTitle.isEmpty else {
            return
        }
        onCategoryCreated?(categoryTitle)
        navigationController?.popViewController(animated: true)
    }
}
