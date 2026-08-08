//
//  ProgressCalculator.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 03/08/2026.
//

import Foundation

struct ProgressCalculator {
    static func calculate(
        consumedCalories: Double,
        consumedProtein: Double,
        consumedCarbs: Double,
        consumedFat: Double,
        target: MacroTarget
    ) -> DailyProgress {
        return DailyProgress(
            consumedCalories: consumedCalories,
            consumedProtein: consumedProtein,
            consumedCarbs: consumedCarbs,
            consumedFat: consumedFat,
            targetCalories: target.calories,
            targetProtein: target.protein,
            targetCarbs: target.carbs,
            targetFat: target.fat
        )
    }
}
