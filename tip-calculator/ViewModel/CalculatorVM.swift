//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by trungnghia on 30/06/2023.
//

import Foundation
import Combine

class CalculatorVM {

    private var subscriptions = Set<AnyCancellable>()

    struct Input {
        let billdPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }

    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resetCalculatorPublisher: AnyPublisher<Void, Never>
    }

    private let audioPlayerService: AudioPlayerService

    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }

    func transform(input: Input) -> Output {

        input.billdPublisher
            .sink { bill in
                print("Bill: \(bill)")
            }.store(in: &subscriptions)

        input.tipPublisher
            .sink { tip in
                print("Tip: \(tip)")
            }.store(in: &subscriptions)

        input.splitPublisher
            .sink { split in
                print("Split: \(split)")
            }.store(in: &subscriptions)

        let updateViewPublisher = Publishers
            .CombineLatest3(input.billdPublisher, input.tipPublisher, input.splitPublisher)
            .flatMap { [unowned self] (bill, tip, split) in
                let totalTip = getTipAmout(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)

                return Just(Result(amountPerPerson: amountPerPerson, totalBill: totalBill, totalTip: totalTip))
            }
            .eraseToAnyPublisher()

        let resetCalculatorPublisher = input.logoViewTapPublisher
            .handleEvents(receiveOutput: { [unowned self] in
                audioPlayerService.playSound()
            })
            .flatMap { Just($0) }
            .eraseToAnyPublisher()

        return Output(
            updateViewPublisher: updateViewPublisher,
            resetCalculatorPublisher: resetCalculatorPublisher)
    }

    private func getTipAmout(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fiftenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(value: let value):
            return Double(value)
        }
    }

}
