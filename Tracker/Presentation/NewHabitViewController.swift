//
//  NewTrackerViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 03.07.25.
//

import UIKit

final class NewHabitViewController: UIViewController, ScheduleViewControllerDelegate {
    
    // MARK: - Public Properties
    
    var onCreate: ((Tracker) -> Void)?
    
    // MARK: - Private Properties
    
    private var selectedCategory: String?
    private var selectedSchedule: [WeekDay] = []
    
    private let categoryValueLabel = UILabel()
    private let scheduleValueLabel = UILabel()
    private var categoryTitleTopConstraint: NSLayoutConstraint?
    private var scheduleTitleTopConstraint: NSLayoutConstraint?
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        textField.layer.cornerRadius = 16
        textField.clearButtonMode = .whileEditing
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let selectionContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let categoryView = UIView()
    private let scheduleView = UIView()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
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
        title = "Новая привычка"
        
        setupUI()
        setupConstraints()
        setupActions()
        validateInput()
    }
    
    // MARK: - Public Methods (ScheduleViewControllerDelegate)
    
    func scheduleViewController(_ viewController: ScheduleViewController, didSelectDays selectedDays: [WeekDay]) {
        updateSchedule(selectedDays)
    }
    
    // MARK: - Private Methods
    
    func updateCategory(_ category: String?) {
        selectedCategory = category
        let isEmpty = category?.isEmpty ?? true
        categoryValueLabel.text = category
        categoryValueLabel.isHidden = isEmpty
        categoryTitleTopConstraint?.constant = isEmpty ? 27 : 15
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        validateInput()
    }
    
    func updateSchedule(_ days: [WeekDay]) {
        selectedSchedule = days
        let allDays = Set(WeekDay.allCases)
        let selectedDaysSet = Set(days)
        
        let text: String
        if selectedDaysSet == allDays {
            text = "Каждый день"
        } else {
            text = days.map { $0.shortTitle }.joined(separator: ", ")
        }
        
        scheduleValueLabel.text = text
        let isEmpty = text.isEmpty
        scheduleValueLabel.isHidden = isEmpty
        scheduleTitleTopConstraint?.constant = isEmpty ? 27 : 15
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        validateInput()
    }
    
    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(selectionContainerView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        selectionContainerView.addSubview(categoryView)
        selectionContainerView.addSubview(separatorLine)
        selectionContainerView.addSubview(scheduleView)
        
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        scheduleView.translatesAutoresizingMaskIntoConstraints = false
        
        configureSelectionView(title: "Категория", valueLabel: categoryValueLabel, in: categoryView)
        configureSelectionView(title: "Расписание", valueLabel: scheduleValueLabel, in: scheduleView)
        
        let catTap = UITapGestureRecognizer(target: self, action: #selector(didTapCategory))
        categoryView.addGestureRecognizer(catTap)
        
        let schTap = UITapGestureRecognizer(target: self, action: #selector(didTapSchedule))
        scheduleView.addGestureRecognizer(schTap)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            selectionContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            selectionContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectionContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectionContainerView.heightAnchor.constraint(equalToConstant: 150),
            
            categoryView.topAnchor.constraint(equalTo: selectionContainerView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: selectionContainerView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: selectionContainerView.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 75),
            
            separatorLine.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            separatorLine.leadingAnchor.constraint(equalTo: selectionContainerView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: selectionContainerView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            scheduleView.topAnchor.constraint(equalTo: separatorLine.bottomAnchor),
            scheduleView.leadingAnchor.constraint(equalTo: selectionContainerView.leadingAnchor),
            scheduleView.trailingAnchor.constraint(equalTo: selectionContainerView.trailingAnchor),
            scheduleView.bottomAnchor.constraint(equalTo: selectionContainerView.bottomAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.44)
        ])
    }
    
    private func configureSelectionView(title: String, valueLabel: UILabel, in containerView: UIView) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        valueLabel.text = ""
        valueLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        valueLabel.font = .systemFont(ofSize: 17)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(arrowImageView)
        
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 27)
        topConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            valueLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -17),
            arrowImageView.widthAnchor.constraint(equalToConstant: 11),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        if containerView == categoryView {
            categoryTitleTopConstraint = topConstraint
        } else if containerView == scheduleView {
            scheduleTitleTopConstraint = topConstraint
        }
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validateInput()
    }
    
    private func validateInput() {
        let isNameFilled = !(nameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let isCategorySelected = selectedCategory != nil && !(selectedCategory?.isEmpty ?? true)
        let isScheduleSelected = !selectedSchedule.isEmpty
        
        createButton.isEnabled = isNameFilled && isCategorySelected && isScheduleSelected
        
        if createButton.isEnabled {
            createButton.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
            createButton.setTitleColor(.white, for: .normal)
        } else {
            createButton.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
            createButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func didTapCategory() {
        print("Выбор категории пока не реализован")
        let tempCategory = "Без категории"
        updateCategory(tempCategory)
    }
    
    @objc private func didTapSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        scheduleVC.selectedDays = Set(selectedSchedule)
        navigationController?.pushViewController(scheduleVC, animated: true)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapCreate() {
        guard createButton.isEnabled else { return }
        guard let name = nameTextField.text, !name.isEmpty else { return }
        guard let category = selectedCategory, !category.isEmpty else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            title: name,
            color: .systemBlue,
            emoji: "🔥",
            schedule: selectedSchedule
        )
        
        onCreate?(newTracker)
        dismiss(animated: true)
    }
}

