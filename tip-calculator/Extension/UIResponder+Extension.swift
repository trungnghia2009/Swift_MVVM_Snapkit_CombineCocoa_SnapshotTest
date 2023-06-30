//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by trungnghia on 30/06/2023.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
