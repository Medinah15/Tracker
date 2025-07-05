//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 05.07.25.
//

import UIKit

// MARK: - Protocol

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleViewController(_ viewController: ScheduleViewController, didSelectDays days: [WeekDay])
}

// MARK: - ViewController

final class ScheduleViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    // MARK: - Private Properties
    
    private var selectedDays: Set<WeekDay> = []
    
    private let contentContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor(red: 230/255, green: 232/255, blue: 235/255, alpha: 0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupDayRows()
        
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        title = "Расписание"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        view.addSubview(contentContainer)
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupDayRows() {
        var previousRow: UIView? = nil
        
        for (index, day) in WeekDay.allCases.enumerated() {
            let row = createDayRow(for: day, tag: index)
            contentContainer.addSubview(row)
            
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
                row.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
                row.heightAnchor.constraint(equalToConstant: 75)
            ])
            
            if let previous = previousRow {
                let separator = createSeparator()
                contentContainer.addSubview(separator)
                
                NSLayoutConstraint.activate([
                    separator.topAnchor.constraint(equalTo: previous.bottomAnchor),
                    separator.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 16),
                    separator.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -16),
                    separator.heightAnchor.constraint(equalToConstant: 1),
                    
                    row.topAnchor.constraint(equalTo: separator.bottomAnchor)
                ])
            } else {
                row.topAnchor.constraint(equalTo: contentContainer.topAnchor).isActive = true
            }
            
            previousRow = row
        }
        
        if let lastRow = previousRow {
            lastRow.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor).isActive = true
        }
    }
    
    private func createDayRow(for day: WeekDay, tag: Int) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        
        let label = UILabel()
        label.text = dayDisplayName(day)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let toggle = UISwitch()
        toggle.isOn = selectedDays.contains(day)
        toggle.tag = tag
        toggle.onTintColor = UIColor.systemBlue
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(label)
        container.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            toggle.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        
        return container
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        return separator
    }
    
    private func dayDisplayName(_ day: WeekDay) -> String {
        switch day {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
    
    private func sortWeekDays(_ a: WeekDay, _ b: WeekDay) -> Bool {
        WeekDay.allCases.firstIndex(of: a)! < WeekDay.allCases.firstIndex(of: b)!
    }
    
    // MARK: - IBActions
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let day = WeekDay.allCases[sender.tag]
        if sender.isOn {
            selectedDays.insert(day)
        } else {
            selectedDays.remove(day)
        }
    }
    
    @objc private func doneButtonTapped() {
           delegate?.scheduleViewController(self, didSelectDays: Array(selectedDays).sorted(by: sortWeekDays))
           navigationController?.popViewController(animated: true)
       }
   }
