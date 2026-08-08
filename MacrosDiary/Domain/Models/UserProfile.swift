//
//  UserProfile.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 20/1/26.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case male = "male"
    case female = "female"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .male: return String(localized: "Male")
        case .female: return String(localized: "Female")
        }
    }
}

enum ActivityLevel: Double, CaseIterable, Identifiable {
    case sedentary = 1.2
    case lightlyActive = 1.375
    case moderatelyActive = 1.55
    case veryActive = 1.725
    case extraActive = 1.9
    
    var id: Double {rawValue}
    
    var title: String {
        switch self {
        case .sedentary: return String(localized: "Sedentary")
        case .lightlyActive:  return String(localized: "Lightly Active")
        case .moderatelyActive: return String(localized: "Moderate Active")
        case .veryActive: return String(localized: "Very Active")
        case .extraActive: return String(localized: "Extra Active")
        }
    }
}

enum GoalType: String, CaseIterable, Identifiable {
    case weightLoss = "weightLoss"
    case maintenance = "maintenance"
    case weightGain = "weightGain"
    
    var id: String {rawValue}
    
    var factor: Double {
        switch self {
        case .weightLoss: return 0.85
        case .maintenance: return 1.0
        case .weightGain: return 1.10
        }
    }
    
    var title: String {
        switch self {
        case .weightLoss: return String(localized: "Weight Loss")
        case .maintenance: return String(localized: "Maintenance")
        case .weightGain: return String(localized: "Weight Gain")
        }
    }
}

struct UserProfile {
    let name: String
    let gender: Gender
    let age: Int
    let height: Double
    let weight: Double
    let activityLevel: ActivityLevel
    let goal: GoalType
    var isAutoCalculate: Bool
}

struct MacroTarget {
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
}

struct ProfileData {
    var profile: UserProfile
    var target: MacroTarget
}
