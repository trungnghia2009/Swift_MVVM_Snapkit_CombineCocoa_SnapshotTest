//
//  HeaderView.swift
//  tip-calculator
//
//  Created by trungnghia on 30/06/2023.
//

import UIKit
import SnapKit

class HeaderView: UIView {

    private let topLabel: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.bold(ofSize: 18))
    }()

    private let bottomLabel: UILabel = {
        LabelFactory.build(text: nil, font: ThemeFont.regular(ofSize: 16))
    }()

    private let topSpacerView = UIView()
    private let bottomSpacerView = UIView()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topSpacerView,
            topLabel,
            bottomLabel,
            bottomSpacerView
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = -4
        return stack
    }()

    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubviews(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topSpacerView.snp.makeConstraints { make in
            make.height.equalTo(bottomSpacerView.snp.height)
        }
    }

    func configure(topText: String, bottomText: String) {
        topLabel.text = topText
        bottomLabel.text = bottomText
    }
}
