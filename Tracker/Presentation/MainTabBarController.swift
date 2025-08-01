//
//  ViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 11.06.25.
//
import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
    }
    
    // MARK: - Private Methods
    
    private func setupAppearance() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViewControllers() {
        let trackersVC = TrackersViewController()
        trackersVC.tabBarItem = UITabBarItem(
            title: NSLocalizedString("tab.trackers.title", comment: "Tab title for trackers screen"),
            image: UIImage(systemName: "record.circle.fill"),
            tag: 0
        )
        
        let context = PersistenceController.shared.viewContext
        
        do {
            let trackerStore = try TrackerStore(context: context)
            let recordStore = try TrackerRecordStore(context: context)
            let viewModel = StatisticsViewModel(recordStore: recordStore, trackerStore: trackerStore)
            let statisticsVC = StatisticsViewController(viewModel: viewModel)
            statisticsVC.tabBarItem = UITabBarItem(
                title: NSLocalizedString("tab.statistics.title", comment: "Tab title for statistics screen"),
                image: UIImage(systemName: "hare.fill"),
                tag: 1
            )
            
            let nav1 = UINavigationController(rootViewController: trackersVC)
            let nav2 = UINavigationController(rootViewController: statisticsVC)
            
            viewControllers = [nav1, nav2]
            
        } catch {
            print("❌ Failed to initialize stores: \(error.localizedDescription)")
        }
    }
}
