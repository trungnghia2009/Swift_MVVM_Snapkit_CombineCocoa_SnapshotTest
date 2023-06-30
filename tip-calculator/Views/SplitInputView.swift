//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by trungnghia on 29/06/2023.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {

    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()

    private lazy var decrementButton: UIButton = {
        let button = buildButton(text: "-", corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        button.tapPublisher
            .flatMap { [unowned self] _ in
                Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
            }
            .assign(to: \.value, on: splitSubject)
            .store(in: &subscriptions)
        return button
    }()

    private lazy var incrementButton: UIButton = {
        let button = buildButton(text: "+", corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner])
        button.tapPublisher
            .flatMap { [unowned self] _ in
                Just(splitSubject.value + 1)
            }
            .assign(to: \.value, on: splitSubject)
            .store(in: &subscriptions)
        return button
    }()

    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(
            text: String(splitSubject.value),
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

    private var subscriptions = Set<AnyCancellable>()

    private let splitSubject = CurrentValueSubject<Int, Never>(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        splitSubject.removeDuplicates().eraseToAnyPublisher()
    }

    init() {
        super.init(frame: .zero)
        layout()
        observe()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reset() {
        splitSubject.send(1)
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

    private func observe() {
        splitSubject.sink { [unowned self] quantity in
            quantityLabel.text = quantity.stringValue
        }.store(in: &subscriptions)

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

