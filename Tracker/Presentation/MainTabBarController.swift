//
//  ViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 11.06.25.
//
import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground() 
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }

        let trackersVC = TrackersViewController()
        let statisticsVC = StatisticsViewController()

        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), tag: 0)
        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), tag: 1)

        let nav1 = UINavigationController(rootViewController: trackersVC)
        let nav2 = UINavigationController(rootViewController: statisticsVC)

        viewControllers = [nav1, nav2]
    }
}
