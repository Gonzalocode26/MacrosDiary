//
//  DailyChartData.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 26/12/25.
//

import SwiftUI

struct DailyChartData: Identifiable {
    let id = UUID()
    let date: Date
    let calories: Double
    let protein: Double
    let carbs: Double
    let fats: Double
}

enum StatType: String, CaseIterable {
    case calories = "Calories"
    case protein = "Protein"
    case carbs = "Carbs"
    case fat = "Fat"
    
    var color: Color {
        switch self {
            case .calories: return .purple
            case .protein: return .red
            case .carbs: return .blue
            case .fat: return .yellow
        }
    }
    
}
