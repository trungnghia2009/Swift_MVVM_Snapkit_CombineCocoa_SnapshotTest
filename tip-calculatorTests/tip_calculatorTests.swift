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

    private var logoViewTapSubject: PassthroughSubject<Void, Never>!
    private var audioPlayerService: MockAudioPlayerService!

    override func setUp() {
        super.setUp()
        audioPlayerService = .init()
        sut = .init(audioPlayerService: audioPlayerService)
        logoViewTapSubject = .init()
        subcriptions = .init()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        subcriptions = nil
        audioPlayerService = nil
        logoViewTapSubject = nil
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

    func test_resultWithoutTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)

        // when
        let ouput = sut.transform(input: input)

        // then
        ouput.updateViewPublisher
            .sink { result in
                XCTAssertEqual(result.amountPerPerson, 50)
                XCTAssertEqual(result.totalBill, 100)
                XCTAssertEqual(result.totalTip, 0)
            }.store(in: &subcriptions)
    }

    func test_resultWith10PercentTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)

        // when
        let ouput = sut.transform(input: input)

        // then
        ouput.updateViewPublisher
            .sink { result in
                XCTAssertEqual(result.amountPerPerson, 55)
                XCTAssertEqual(result.totalBill, 110)
                XCTAssertEqual(result.totalTip, 10)
            }.store(in: &subcriptions)
    }

    func test_resultWith15PercentTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .fiftenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)

        // when
        let ouput = sut.transform(input: input)

        // then
        ouput.updateViewPublisher
            .sink { result in
                XCTAssertEqual(result.amountPerPerson, 57.5)
                XCTAssertEqual(result.totalBill, 115)
                XCTAssertEqual(result.totalTip, 15)
            }.store(in: &subcriptions)
    }

    func test_resultWith20PercentTipFor2Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .twentyPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)

        // when
        let ouput = sut.transform(input: input)

        // then
        ouput.updateViewPublisher
            .sink { result in
                XCTAssertEqual(result.amountPerPerson, 60)
                XCTAssertEqual(result.totalBill, 120)
                XCTAssertEqual(result.totalTip, 20)
            }.store(in: &subcriptions)
    }

    func test_resultWithCustomTipFor4Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .custom(value: 40)
        let split: Int = 4
        let input = buildInput(bill: bill, tip: tip, split: split)

        // when
        let ouput = sut.transform(input: input)

        // then
        ouput.updateViewPublisher
            .sink { result in
                XCTAssertEqual(result.amountPerPerson, 35)
                XCTAssertEqual(result.totalBill, 140)
                XCTAssertEqual(result.totalTip, 40)
            }.store(in: &subcriptions)
    }

    func test_soundPlayed_and_calculatorResetOnLogoViewTap() {
        // given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "Reset calculator called")
        let expectation2 = audioPlayerService.expectation

        // then
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &subcriptions)

        // when
        logoViewTapSubject.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    

    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorVM.Input {
        return .init(
            billdPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
}

class MockAudioPlayerService: AudioPlayerService {
    var expectation = XCTestExpectation(description: "Play sound is called")

    func playSound() {
        expectation.fulfill()
    }
}
