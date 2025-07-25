//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 06.07.25.
//
import UIKit

// MARK: - CategoryViewController

final class CategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - Private Properties
    
    private let viewModel: CategoryViewModel
    
    // MARK: - UI Elements
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        return tableView
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: "trackers_placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 2
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
    
    // MARK: - Init
    
    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Категория"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        
        setupLayout()
        setupActions()
        bindViewModel()
        viewModel.fetchCategories()
    }
    
    // MARK: - Private Methods
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -12),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        addCategoryButton.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] _ in
            self?.tableView.reloadData()
            self?.placeholderView.isHidden = !(self?.viewModel.categories.isEmpty ?? true)
        }
    }
    
    private func showEditCategoryAlert(for index: Int) {
        guard index < viewModel.categories.count else { return }
        let currentTitle = viewModel.categories[index].title
        
        let editVC = EditCategoryViewController(index: index, initialTitle: currentTitle)
        editVC.onCategoryUpdated = { [weak self] updatedIndex, newTitle in
            self?.viewModel.updateCategory(at: updatedIndex, newTitle: newTitle)
            self?.viewModel.fetchCategories()
        }
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func showDeleteConfirmationAlert(for index: Int) {
        guard index < viewModel.categories.count else { return }
        let categoryTitle = viewModel.categories[index].title
        
        let alert = UIAlertController(title: "Эта категория точно не нужна", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(at: index)
            self?.viewModel.fetchCategories()
        })
        present(alert, animated: true)
    }
    
    // MARK: - IBAction
    
    @objc private func addCategoryTapped() {
        let newCategoryVC = NewCategoryViewController()
        newCategoryVC.onCategoryCreated = { [weak self] newCategoryTitle in
            self?.viewModel.addCategory(title: newCategoryTitle)
            self?.viewModel.fetchCategories()
        }
        navigationController?.pushViewController(newCategoryVC, animated: true)
    }
}
// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        let category = viewModel.categories[indexPath.row]
        let isSelected = viewModel.selectedCategoryIndex == indexPath.row
        let bgColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        let cellViewModel = CategoryCellViewModel(title: category.title, backgroundColor: bgColor, isSelected: isSelected)
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        if let selectedCategory = viewModel.selectedCategory {
            onCategorySelected?(selectedCategory)
        }
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { [weak self] _, _, done in
            self?.showEditCategoryAlert(for: indexPath.row)
            done(true)
        }
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, done in
            self?.showDeleteConfirmationAlert(for: indexPath.row)
            done(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { _ in
            let edit = UIAction(title: "Редактировать") { [weak self] _ in
                self?.showEditCategoryAlert(for: indexPath.row)
            }
            let delete = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.showDeleteConfirmationAlert(for: indexPath.row)
            }
            return UIMenu(title: "", children: [edit, delete])
        }
    }
    
    func didSelectCategory(at index: Int) {
        guard index < viewModel.categories.count else { return }
        let selectedCategory = viewModel.categories[index]
        let newHabitVC = NewHabitViewController()
        newHabitVC.selectedCategory = selectedCategory
        navigationController?.pushViewController(newHabitVC, animated: true)
    }
}
