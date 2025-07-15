//
//  UITextField+Padding.swift
//  Tracker
//
//  Created by Medina Huseynova on 05.07.25.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}
