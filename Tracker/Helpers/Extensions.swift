//
//  Extensions.swift
//  Tracker
//
//  Created by Medina Huseynova on 27.06.25.
//

import Foundation

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

