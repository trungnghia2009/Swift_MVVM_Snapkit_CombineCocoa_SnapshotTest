//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by trungnghia on 30/06/2023.
//

import Foundation
import Combine

class CalculatorVM {

    struct Input {
        let billdPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }

    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
    }

    func transform(input: Input) -> Output {
        let result = Result(
            amountPerPerson: 500,
            totalBill: 1000,
            totalTip: 50)


        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
    }
}
