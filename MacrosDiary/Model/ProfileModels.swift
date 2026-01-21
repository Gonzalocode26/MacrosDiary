//
//  ProfileModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 20/1/26.
//

import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    var id: String {rawValue}
}
enum UserActivity: Double, CaseIterable, Identifiable {
    case sedentary = 1.2
    case lightlyActive = 1.375
    case moderatelyActive = 1.55
    case veryActive = 1.725
    case extraActive = 1.9
    
    var id: Double {rawValue}
    
    var title: String {
        switch self {
            case .sedentary: return "Sedentary"
            case .lightlyActive:  return "Ligthly Active"
            case .moderatelyActive: return "Moderate Active"
            case .veryActive: return "Very Active"
            case .extraActive: return "Extra Active"
        }
    }
}
enum GoalType: String, CaseIterable, Identifiable {
    case weightLoss = "Weight Loss"
    case maintenance = "Maintenance"
    case weightGain = "Weight Gain"
    
    var id: String {rawValue}
    
    var factor: Double {
        switch self {
            case .weightLoss: return 0.85
            case .maintenance: return 1.0
            case .weightGain: return 1.10
        }
    }
}
