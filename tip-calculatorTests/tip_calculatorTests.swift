//
//  tip_calculatorTests.swift
//  tip-calculatorTests
//
//  Created by trungnghia on 29/06/2023.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorTests: XCTestCase {

    private var sut: CalculatorVM!
    private var subcriptions: Set<AnyCancellable>!

    private let logoViewTapSubject = PassthroughSubject<Void, Never>()

    override func setUp() {
        super.setUp()
        sut = .init()
        subcriptions = .init()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        subcriptions = nil
    }

    func test_resultWithoutTipFor1Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(bill: bill, tip: tip, split: split)

        // when
        let ouput = sut.transform(input: input)

        // then
        ouput.updateViewPublisher
            .sink { result in
                XCTAssertEqual(result.amountPerPerson, 100)
                XCTAssertEqual(result.totalBill, 100)
                XCTAssertEqual(result.totalTip, 0)
            }.store(in: &subcriptions)


    }

    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorVM.Input {
        return .init(
            billdPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
}
