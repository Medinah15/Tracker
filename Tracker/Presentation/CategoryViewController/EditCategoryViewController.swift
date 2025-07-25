//
//  EditCategoryViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 25.07.25.
//

import UIKit

final class EditCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onCategoryUpdated: ((Int, String) -> Void)?
    
    // MARK: - Private Properties
    
    private let categoryIndex: Int
    private let initialTitle: String
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название категории"
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Init
    
    init(index: Int, initialTitle: String) {
        self.categoryIndex = index
        self.initialTitle = initialTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Редактирование категории"
        navigationItem.hidesBackButton = true
        
        setupViews()
        setupConstraints()
        setupActions()
        
        categoryTextField.text = initialTitle
        updateSaveButtonState()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        view.addSubview(categoryTextField)
        view.addSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 75),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func setupActions() {
        categoryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func updateSaveButtonState() {
        let hasText = !(categoryTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        saveButton.isEnabled = hasText
        saveButton.backgroundColor = hasText ? UIColor.black : UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
    
    // MARK: - IBAction
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    @objc private func saveButtonTapped() {
        guard let newTitle = categoryTextField.text?.trimmingCharacters(in: .whitespaces),
              !newTitle.isEmpty else {
            return
        }
        onCategoryUpdated?(categoryIndex, newTitle)
        navigationController?.popViewController(animated: true)
    }
}
