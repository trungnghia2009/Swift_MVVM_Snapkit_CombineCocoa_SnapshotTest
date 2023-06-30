//
//  TipInputView.swift
//  tip-calculator
//
//  Created by trungnghia on 29/06/2023.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {

    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Choose", bottomText: "your tip")
        return view
    }()

    private lazy var tenPercentTipBtn: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        button.tapPublisher
            .flatMap { Just(Tip.tenPercent) }
            .assign(to: \.value, on: tipSubject)
            .store(in: &subscriptions)
        return button
    }()

    private lazy var fiftenPercentTipBtn: UIButton = {
        let button = buildTipButton(tip: .fiftenPercent)
        button.tapPublisher
            .flatMap { Just(Tip.fiftenPercent) }
            .assign(to: \.value, on: tipSubject)
            .store(in: &subscriptions)
        return button
    }()

    private lazy var twentyPercentTipBtn: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher
            .flatMap { Just(Tip.twentyPercent) }
            .assign(to: \.value, on: tipSubject)
            .store(in: &subscriptions)
        return button
    }()

    private lazy var buttonHStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            tenPercentTipBtn,
            fiftenPercentTipBtn,
            twentyPercentTipBtn
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually

        return stack
    }()

    private lazy var customTipBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        button.tapPublisher
            .sink { [unowned self] _ in
                handleCustomTipBtn()
            }.store(in: &subscriptions)

        return button
    }()

    private lazy var buttonVStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipBtn
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillEqually

        return stack
    }()

    private var subscriptions = Set<AnyCancellable>()

    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        tipSubject.eraseToAnyPublisher()
    }

    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        addSubviews(headerView, buttonVStackView)

        buttonVStackView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }

    private func handleCustomTipBtn() {
        let alertController: UIAlertController = {
            let alert = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)

            alert.addTextField { textField in
                textField.placeholder = "Make it generous!"
                textField.keyboardType = .numberPad
                textField.autocorrectionType = .no
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                guard let text = alert.textFields?.first?.text,
                      let value = Int(text) else { return }
                self?.tipSubject.send(.custom(value: value))
            }

            alert.addAction(okAction)
            alert.addAction(cancelAction)

            return alert
        }()

        parentViewController?.present(alertController, animated: true)
    }

    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8.0)

        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(ofSize: 20),
                .foregroundColor: UIColor.white])

        text.addAttributes([.font: ThemeFont.demiBold(ofSize: 14)], range: NSMakeRange(2, 1))
        button.setAttributedTitle(text, for: .normal)

        return button
    }

}
