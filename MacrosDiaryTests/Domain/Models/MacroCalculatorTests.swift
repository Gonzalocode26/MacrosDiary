//
//  MacroCalculatorTests.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 10/08/2026.
//

import XCTest
@testable import MacrosDiary

final class MacroCalculatorTests: XCTestCase {
    func test_calculate_whenUserIsMaleAndActiveLosingWeight_returnsCorrectLossCalories() {
        // 1. ARRANGE
        let profile = UserProfile(
            name: "Gonzalo",
            gender: .male,
            age: 26,
            height: 176,
            weight: 76,
            activityLevel: .moderatelyActive,
            goal: .weightLoss,
            isAutoCalculate: true
        )
        
        // 2. ACT
        let target = MacroCalculator.calculate(for: profile)
        
        // 3. ASSERT
        XCTAssertEqual(target.calories, 2285.86, accuracy: 0.1, "Failed in calories")
        XCTAssertEqual(target.protein, 152.0, accuracy: 0.1, "Failed in protein")
        XCTAssertEqual(target.carbs, 257.16, accuracy: 0.1, "Failed in carbs")
        XCTAssertEqual(target.fat, 72.13, accuracy: 0.1, "Failed in fat")
    }
}
