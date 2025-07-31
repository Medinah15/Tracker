//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Medina Huseynova on 31.07.25.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testTrackersViewControllerLightMode() {
        let vc = TrackersViewController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDarkMode() {
        let vc = TrackersViewController()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
