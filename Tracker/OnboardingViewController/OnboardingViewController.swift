//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Medina Huseynova on 22.07.25.
//
import UIKit

final class OnboardingViewController: UIPageViewController {
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Properties
    
    lazy var pages: [UIViewController] = {
        [
            OnboardingPageViewController(backgroundImageName: "blueScreenImage", titleText: "Отслеживайте только то, что хотите"),
            OnboardingPageViewController(backgroundImageName: "redScreenImage", titleText: "Даже если это не литры воды и йога")
        ]
    }()
    
    // MARK: - Private Properties
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = pages.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private lazy var techButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(techButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true)
        }
        
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupSubviews() {
        view.addSubview(pageControl)
        view.addSubview(techButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            techButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            techButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            techButton.widthAnchor.constraint(equalToConstant: 335 ),
            techButton.heightAnchor.constraint(equalToConstant: 60),
            techButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            techButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pageControl.bottomAnchor.constraint(equalTo: techButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - IBActions
    
    @objc private func techButtonTapped() {
        UserDefaults.standard.set(true, forKey: "isOnboardingSeen")
        UserDefaults.standard.synchronize()
        
        let trackersVC = TrackersViewController()
        let navVC = UINavigationController(rootViewController: trackersVC)
        
        guard let windowScene = view.window?.windowScene else { return }
        if let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = navVC
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: nil)
        }
    }
}

// MARK: UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

// MARK: UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if let currentVC = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentVC) {
            pageControl.currentPage = index
        }
    }
}
