//
//  ProgressCalculatorTests.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 10/08/2026.
//

import XCTest
@testable import MacrosDiary

final class ProgressCalculatorTests: XCTestCase {
    func test_calculateProgress_returnsZeroPercentageToAvoidNaN() {
        // 1. ARRANGE
        let zeroTarget = MacroTarget(
            calories: 0,
            protein: 0,
            carbs: 0,
            fat: 0
        )
        
        // 2. ACT
        let progress = ProgressCalculator.calculate(
            consumedCalories: 500,
            consumedProtein: 30,
            consumedCarbs: 50,
            consumedFat: 15,
            target: zeroTarget
        )
        
        // 3. ASSERT
        XCTAssertEqual(progress.caloriePercentage, 0.0, "Calories % should be 0.0, not NaN")
        XCTAssertEqual(progress.proteinPercentage, 0.0, "Protein % should be 0.0, not NaN")
        XCTAssertEqual(progress.carbsPercentage, 0.0, "Carbs % should be 0.0, not NaN")
        XCTAssertEqual(progress.fatPercentage, 0.0, "Fat % should be 0.0, not NaN")
    }
}
