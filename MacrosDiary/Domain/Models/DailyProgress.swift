//
//  DailyProgress.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 03/08/2026.
//

import Foundation

struct DailyProgress {
    let consumedCalories: Double
    let consumedProtein: Double
    let consumedCarbs: Double
    let consumedFat: Double
    
    let targetCalories: Double
    let targetProtein: Double
    let targetCarbs: Double
    let targetFat: Double
    
    var caloriePercentage: Double {
        targetCalories > 0 ? consumedCalories / targetCalories : 0
    }
    
    var proteinPercentage: Double {
        targetProtein > 0 ? consumedProtein / targetProtein : 0
    }
    
    var carbsPercentage: Double {
        targetCarbs > 0 ? consumedCarbs / targetCarbs : 0
    }
    
    var fatPercentage: Double {
        targetFat > 0 ? consumedFat / targetFat : 0
    }
}
