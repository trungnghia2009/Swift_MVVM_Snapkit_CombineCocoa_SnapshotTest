//
//  ViewController.swift
//  tip-calculator
//
//  Created by trungnghia on 29/06/2023.
//

///https://coolors.co/palettes/trending

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {

    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()

    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView() // Fix layout issue
        ])

        stackView.axis = .vertical
        stackView.spacing = 36

        return stackView
    }()

    private let vm = CalculatorVM()
    private var subscriptions = Set<AnyCancellable>()

    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()

    private lazy var logoTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        logoView.addGestureRecognizer(tapGesture)
        return tapGesture.tapPublisher.flatMap { _ in
            Just(())
        }.eraseToAnyPublisher()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }

    private func bind() {
        let input = CalculatorVM.Input(
            billdPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher)

        let output = vm.transform(input: input)
        output.updateViewPublisher
            .sink { [weak self] result in
                self?.resultView.configure(result: result)
            }.store(in: &subscriptions)
    }

    private func observe() {
        viewTapPublisher.sink { [unowned self] _ in
            view.endEditing(true)
        }.store(in: &subscriptions)

        logoTapPublisher.sink { _ in
            print("did tap 2 times on logo view")
        }.store(in: &subscriptions)
    }

    private func layout() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)

        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
        }

        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        resultView.snp.makeConstraints { make in
            make.height.equalTo(224)
        }

        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56 + 56 + 12)
        }

        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }


}

