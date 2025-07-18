//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 13.06.25.
//
import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var categories: [TrackerCategory] = []
    private var selectedDate = Date()
    private var searchText: String = ""
    private var trackerStore: TrackerStore!
    private var trackerRecordStore: TrackerRecordStore!
    
    // MARK: - UI Elements
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInset.top = 24
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(TrackerHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackerHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .black
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: "trackers_placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Трекеры"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        let context = PersistenceController.shared.container.viewContext
        trackerStore = try? TrackerStore(context: context)
        trackerStore.delegate = self
        
        trackerRecordStore = try? TrackerRecordStore(context: context)
        trackerRecordStore.delegate = self
        
        
        setupNavigationBar()
        setupSearchController()
        setupCollectionView()
        setupPlaceholderView()
        reloadVisibleCategories()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupPlaceholderView() {
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        placeholderView.isHidden = true
    }
    
    // MARK: - Data Handling
    
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: selectedDate)
        guard let weekday = WeekDay.fromCalendarIndex(weekdayIndex) else { return }
        
        let filtered = trackerStore.categories.map { category in
            let trackers = category.trackers.filter {
                $0.schedule.contains(weekday) &&
                (searchText.isEmpty || $0.title.lowercased().contains(searchText.lowercased()))
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        }.filter { !$0.trackers.isEmpty }
        
        categories = filtered
        placeholderView.isHidden = !categories.isEmpty
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func dateChanged() {
        selectedDate = datePicker.date
        reloadVisibleCategories()
    }
    
    @objc private func didTapAdd() {
        let newHabitVC = NewHabitViewController()
        newHabitVC.onCreate = { [weak self] tracker in
            guard let self = self else { return }
            try? self.trackerStore.addTracker(tracker, toCategoryTitle: tracker.title)
            self.reloadVisibleCategories()
        }
        let nav = UINavigationController(rootViewController: newHabitVC)
        present(nav, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        reloadVisibleCategories()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        reloadVisibleCategories()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as! TrackerCell
        
        let tracker = categories[indexPath.section].trackers[indexPath.item]
        let isCompleted = trackerRecordStore.isCompleted(tracker.id, on: selectedDate)
        let count = trackerRecordStore.records.filter { $0.trackerId == tracker.id }.count
        
        cell.configure(title: tracker.title, emoji: tracker.emoji, color: tracker.color, isCompleted: isCompleted, count: count)
        cell.onTap = { [weak self] in
            guard let self = self else { return }
            
            if Calendar.current.isDateInFuture(self.selectedDate) { return }
            
            let isCompleted = self.trackerRecordStore.isCompleted(tracker.id, on: self.selectedDate)
            
            if isCompleted {
                try? self.trackerRecordStore.removeRecord(for: tracker.id, on: self.selectedDate)
            } else {
                try? self.trackerRecordStore.addRecord(for: tracker.id, on: self.selectedDate)
            }
            
            self.reloadVisibleCategories()
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerHeaderView else {
            return UICollectionReusableView()
        }
        let categoryTitle = categories[indexPath.section].title
        header.configure(title: categoryTitle)
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 41) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 226, height: 18)
    }
}

extension TrackersViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        reloadVisibleCategories()
    }
}

extension TrackersViewController: TrackerRecordStoreDelegate {
    func store(_ store: TrackerRecordStore, didUpdate update: TrackerRecordStoreUpdate) {
        reloadVisibleCategories()
    }
}
