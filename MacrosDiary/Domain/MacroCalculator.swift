//
//  MacroCalculator.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 02/08/2026.
//

import Foundation

struct MacroCalculator {
    static func calculate(for profile: UserProfile) -> MacroTarget {
        // MARK: - Mifflin formula
        
        let weightPart = profile.weight * 10
        let heightPart = profile.height * 6.25
        let agePart = Double(profile.age) * 5
        let genderCorrection: Double = (profile.gender == .male) ? 5 : -161
        
        let formula = weightPart + heightPart - agePart + genderCorrection
        let tdee = formula * profile.activityLevel.rawValue
        let targetCalories = tdee * profile.goal.factor
        
        //       PROTEIN STANDARD - 2gs x kg
        let targetProtein = profile.weight * 2.0
        
        //        CARBS STANDARD - DEPENDS ON ACTIVITY LEVEL
        var carbPercentage: Double = 0.45
        
        switch profile.activityLevel {
        case .sedentary:
            carbPercentage = 0.40
        case .lightlyActive:
            carbPercentage = 0.45
        case .moderatelyActive:
            carbPercentage = 0.50
        case .veryActive, .extraActive:
            carbPercentage = 0.55
        }
        
        // MARK: - Goal
        
        if profile.goal == .weightLoss { carbPercentage -= 0.05 }
        
        let caloriesForCarbs = targetCalories * carbPercentage
        let targetCarbs = caloriesForCarbs / 4
        
        // MARK: - Fat
        
        let caloriesUsed = (targetProtein * 4) + (targetCarbs * 4)
        let remainingCalories = targetCalories - caloriesUsed
        let calculatedFat = remainingCalories / 9
        let minFat = profile.weight * 0.5
        let targetFat = max(calculatedFat, minFat)
        
        return MacroTarget(
            calories: targetCalories,
            protein: targetProtein,
            carbs: targetCarbs,
            fat: targetFat
        )
    }
}
