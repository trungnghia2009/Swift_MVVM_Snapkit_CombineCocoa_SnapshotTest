//
//  BillInputView.swift
//  tip-calculator
//
//  Created by trungnghia on 29/06/2023.
//

import UIKit

class BillInputView: UIView {

    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        backgroundColor = .green
    }

}
