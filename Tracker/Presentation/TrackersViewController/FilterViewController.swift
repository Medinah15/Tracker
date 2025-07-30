//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 30.07.25.
//
import UIKit

// MARK: - FilterViewController

final class FilterViewController: UIViewController {

    // MARK: - Public Properties

    var onFilterSelected: (( TrackerFilter) -> Void)?
    var selectedFilter:  TrackerFilter?

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(FilterTableViewCell.self, forCellReuseIdentifier: "FilterCell")
        return tableView
    }()

    private let filters: [TrackerFilter] = [.all, .today, .completed, .uncompleted]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Фильтры"
        view.backgroundColor = .systemBackground
        // ✅ Если фильтр не установлен — ставим .all
            if selectedFilter == nil {
                selectedFilter = .all
            }

            setupLayout()
    }

    // MARK: - Private Methods

    private func setupLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
                tableView.widthAnchor.constraint(equalToConstant: 343),
                tableView.heightAnchor.constraint(equalToConstant: 300),
                tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
            ])
        }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        
        let filter = filters[indexPath.row]

        // Галочка — только если это выбранный фильтр и он НЕ .all и НЕ .today
        let isSelected = (filter == selectedFilter) && (filter != .all) && (filter != .today)

        cell.configure(title: filter.title, isSelected: isSelected)

        
        cell.backgroundColor = .clear
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filter = filters[indexPath.row]
        selectedFilter = filter
        onFilterSelected?(filter)// Обновляем выбранный фильтр
        tableView.reloadData()                     // Перерисовываем таблицу для галочки

        // Ждём чуть-чуть, чтобы галочка успела появиться
        dismiss(animated: true)
        }
    }

