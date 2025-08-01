//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 01.08.25.
//
import UIKit

final class StatisticsViewController: UIViewController {

    private let viewModel: StatisticsViewModel
    
    init(viewModel: StatisticsViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: UIImage(named: "statistics_placeholder"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = NSLocalizedString("statistics_placeholder", comment: " ")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "CounterLabelText")
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

    private func setupPlaceholderView() {
        view.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupPlaceholderView()
        navigationItem.title = NSLocalizedString("statistics_title", comment: "Title of the Statistics screen")
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        viewModel.onDataChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        viewModel.updateStatistics()

    }

    private func setupViews() {

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }

    private func updateUI() {
        print("⚙️ updateUI called, completedCount = \(viewModel.completedCount)")
        let stats = [
            ("Лучший период", viewModel.bestPeriod),
            ("Идеальные дни", viewModel.idealDays),
            ("Трекеров завершено", viewModel.completedCount),
            ("Среднее значение", viewModel.averagePerDay)
        ]

        if viewModel.completedCount == 0 {
            placeholderView.isHidden = false
            stackView.isHidden = true
        } else {
            placeholderView.isHidden = true
            stackView.isHidden = false
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            for stat in stats {
                let view = StatisticCardView(title: stat.0, value: stat.1)
                stackView.addArrangedSubview(view)
            }
        }
    }
}
