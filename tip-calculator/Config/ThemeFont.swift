//
//  ThemeFont.swift
//  tip-calculator
//
//  Created by trungnghia on 29/06/2023.
//

import UIKit

struct ThemeFont {

    static func regular(ofSize size: CGFloat) -> UIFont {
        return getFont(name: "AvenirNext-Regular", size: size)
    }

    static func bold(ofSize size: CGFloat) -> UIFont {
        return getFont(name: "AvenirNext-Bold", size: size)
    }

    static func demiBold(ofSize size: CGFloat) -> UIFont {
        return getFont(name: "AvenirNext-DemiBold", size: size)
    }

    private static func getFont(name: String, size: CGFloat) -> UIFont {
        UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
    }
}
