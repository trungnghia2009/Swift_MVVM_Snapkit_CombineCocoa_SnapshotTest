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
    }

    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
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

        let result = Result(
            amountPerPerson: 500,
            totalBill: 1000,
            totalTip: 50)

        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
}
