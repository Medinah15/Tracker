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
    
    private let emojis = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
        "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let colors: [UIColor] = [
        UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1),
        UIColor(red: 255/255, green: 136/255, blue: 30/255, alpha: 1),
        UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1),
        UIColor(red: 110/255, green: 68/255, blue: 254/255, alpha: 1),
        UIColor(red: 51/255, green: 207/255, blue: 105/255, alpha: 1),
        UIColor(red: 230/255, green: 109/255, blue: 212/255, alpha: 1),
        UIColor(red: 249/255, green: 212/255, blue: 212/255, alpha: 1),
        UIColor(red: 52/255, green: 167/255, blue: 254/255, alpha: 1),
        UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1),
        UIColor(red: 53/255, green: 52/255, blue: 124/255, alpha: 1),
        UIColor(red: 255/255, green: 103/255, blue: 77/255, alpha: 1),
        UIColor(red: 255/255, green: 153/255, blue: 204/255, alpha: 1),
        UIColor(red: 246/255, green: 196/255, blue: 139/255, alpha: 1),
        UIColor(red: 121/255, green: 148/255, blue: 245/255, alpha: 1),
        UIColor(red: 131/255, green: 44/255, blue: 241/255, alpha: 1),
        UIColor(red: 173/255, green: 86/255, blue: 218/255, alpha: 1),
        UIColor(red: 141/255, green: 114/255, blue: 230/255, alpha: 1),
        UIColor(red: 47/255, green: 208/255, blue: 88/255, alpha: 1)
    ]
    
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    
    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .onDrag
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HabitTrackerLayoutFactory.createEmojiLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        
        let itemsInRow: CGFloat = 6
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: HabitTrackerLayoutFactory.createColorLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false // Важно: отключаем скролл коллекции
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collectionView.register(CollectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CollectionHeaderView.reuseIdentifier)
        return collectionView
    }()
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(selectionContainerView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        contentView.addSubview(cancelButton)
        contentView.addSubview(createButton)
        
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
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            selectionContainerView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            selectionContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            selectionContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
            
            emojiCollectionView.topAnchor.constraint(equalTo: selectionContainerView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 34),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 204),
            
            cancelButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.44),
            
            createButton.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 40),
            createButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.44),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8),
            createButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
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
        let isEmojiSelected = selectedEmojiIndex != nil
        let isColorSelected = selectedColorIndex != nil
        
        createButton.isEnabled = isNameFilled && isCategorySelected && isScheduleSelected && isEmojiSelected && isColorSelected
        
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
        
        guard let emojiIndex = selectedEmojiIndex else { return }
        guard let colorIndex = selectedColorIndex else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            title: name,
            color: colors[colorIndex.item],
            emoji: emojis[emojiIndex.item],
            schedule: selectedSchedule
        )
        
        onCreate?(newTracker)
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension NewHabitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView { return emojis.count }
        else { return colors.count }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as! EmojiCell
            cell.configure(with: emojis[indexPath.item], selected: indexPath == selectedEmojiIndex)
            return cell
        } else if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as! ColorCell
            cell.configure(with: colors[indexPath.item], selected: indexPath == selectedColorIndex)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionHeaderView.reuseIdentifier,
            for: indexPath) as! CollectionHeaderView
        
        if collectionView == emojiCollectionView {
            header.configure(with: "Emoji")
        } else if collectionView == colorCollectionView {
            header.configure(with: "Цвет")
        }
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension NewHabitViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let prev = selectedEmojiIndex
            selectedEmojiIndex = indexPath
            
            var indexesToReload = [indexPath]
            if let prev = prev, prev != indexPath {
                indexesToReload.append(prev)
            }
            collectionView.reloadItems(at: indexesToReload)
        } else if collectionView == colorCollectionView {
            let prev = selectedColorIndex
            selectedColorIndex = indexPath
            
            var indexesToReload = [indexPath]
            if let prev = prev, prev != indexPath {
                indexesToReload.append(prev)
            }
            collectionView.reloadItems(at: indexesToReload)
        }
        
        validateInput()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}
