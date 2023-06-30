//
//  tip_calculatorSnapshotTests.swift
//  tip-calculatorTests
//
//  Created by trungnghia on 30/06/2023.
//

import XCTest
import SnapshotTesting
@testable import tip_calculator

final class tip_calculatorSnapshotTests: XCTestCase {

    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    func testLogoView() {
        // given
        let size = CGSize(width: screenWidth, height: 48)
        // when
        let view = LogoView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }

    func testInitialResultView() {
        // given
        let size = CGSize(width: screenWidth, height: 224)
        // when
        let view = ResultView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }

    func testInitialBillInputView() {
        // given
        let size = CGSize(width: screenWidth, height: 56)
        // when
        let view = BillInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }

    func testInitialTipInputView() {
        // given
        let size = CGSize(width: screenWidth, height: 56+56+12)
        // when
        let view = TipInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }

    func testInitialSplitInputView() {
        // given
        let size = CGSize(width: screenWidth, height: 56)
        // when
        let view = SplitInputView()
        // then
        assertSnapshot(matching: view, as: .image(size: size))
    }

}
