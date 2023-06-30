//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by trungnghia on 29/06/2023.
//

import UIKit

class SplitInputView: UIView {

    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()

    private lazy var decrementButton: UIButton = {
        let button = buildButton(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        return button
    }()

    private lazy var incrementButton: UIButton = {
        let button = buildButton(text: "+", corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        return button
    }()

    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(
            text: "1",
            font: ThemeFont.bold(ofSize: 20),
            backgroundColor: .white)
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
        ])
        stack.axis = .horizontal
        stack.spacing = 0

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
        addSubviews(headerView, stackView)

        stackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }

        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }

        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }

    private func buildButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 28)
        button.addRoundedCorners(corners: corners, radius: 8.0)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        return button
    }

}

