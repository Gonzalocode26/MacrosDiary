//
//  ProfileViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 21/1/26.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var genderRaw: String
    
    @Published var age: Int
    @Published var height: Double
    @Published var weight: Double
    @Published var activityRaw: Double
    
    @Published var goalRaw: String
    @Published var calorieGoal: Double
    @Published var proteinGoal: Double
    @Published var carbsGoal: Double
    @Published var fatGoal: Double
    @Published var isAutoCalculate: Bool
    
    @Published var name: String
    
    init() {
        let defaults = UserDefaults.standard
        
        self.name = defaults.string(forKey: "user_name") ?? "User"
        self.genderRaw = defaults.string(forKey: "user_gender") ?? "Male"
        self.age = defaults.integer(forKey: "user_age") != 0 ? defaults.integer(forKey: "user_age") : 25
        self.height = defaults.double(forKey: "user_height") != 0 ? defaults.double(forKey: "user_height") : 175.0
        self.weight = defaults.double(forKey: "user_weight") != 0 ? defaults.double(forKey: "user_weight") : 75.8
        self.activityRaw = defaults.double(forKey: "user_activity") != 0 ? defaults.double(forKey: "user_activity") : 1.725
        self.goalRaw = defaults.string(forKey: "user_goal") ?? "Weight Gain"
        
        self.calorieGoal = defaults.double(forKey: "calorie_goal") != 0 ? defaults.double(forKey: "calorie_goal") : 2000
        self.proteinGoal = defaults.double(forKey: "protein_goal") != 0 ? defaults.double(forKey: "protein_goal") : 150
        self.carbsGoal = defaults.double(forKey: "carbs_goal") != 0 ? defaults.double(forKey: "carbs_goal") : 250
        self.fatGoal = defaults.double(forKey: "fat_goal") != 0 ? defaults.double(forKey: "fat_goal") : 60
        
        self.isAutoCalculate = defaults.bool(forKey: "auto_calculate")
    }
    
    var gender: Gender {
        get {
            return Gender(rawValue: genderRaw) ?? .male
        }
        set {
            genderRaw = newValue.rawValue
        }
    }
    
    var activityLevel: UserActivity {
        get {
            return UserActivity(rawValue: activityRaw) ?? .veryActive
        }
        set {
            activityRaw = newValue.rawValue
        }
    }
    
    var selectedGoal: GoalType {
        get {
            return GoalType(rawValue: goalRaw) ?? .weightGain
        }
        set {
            goalRaw = newValue.rawValue
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        
        defaults.set(self.name, forKey: "user_name")
        defaults.set(self.genderRaw, forKey: "user_gender")
        defaults.set(self.age, forKey: "user_age")
        defaults.set(self.height, forKey: "user_height")
        defaults.set(self.weight, forKey: "user_weight")
        defaults.set(self.activityRaw, forKey: "user_activity")
        defaults.set(self.goalRaw, forKey: "user_goal")
        defaults.set(self.calorieGoal, forKey: "calorie_goal")
        defaults.set(self.proteinGoal, forKey: "protein_goal")
        defaults.set(self.carbsGoal, forKey: "carbs_goal")
        defaults.set(self.fatGoal, forKey: "fat_goal")
        defaults.set(self.isAutoCalculate, forKey: "auto_calculate")
        
    }
    
    func recalculateMacros() -> Void {
        
        guard isAutoCalculate else {return save()}
        
        let weightPart = weight * 10
        let heightPart = height * 6.25
        let agePart = Double(age) * 5
        let genderCorrection: Double = (gender == .male) ? 5 : -161
        
        //        Mifflin-St Jeor formula
        let formula = weightPart + heightPart  - agePart + genderCorrection
        
        let tdee = formula * activityLevel.rawValue
        let targetCalories = tdee * selectedGoal.factor
        
        
        self.calorieGoal = targetCalories
        
        //       PROTEIN STANDARD - 2gs x kg
        let targetProtein = weight * 2.0
        
        //        CARBS STANDARD - DEPENDS ON ACTIVITY LEVEL
        var carbPercentage: Double = 0.45
        
        switch activityLevel {
            case .sedentary:
                carbPercentage = 0.40
            case .lightlyActive:
                carbPercentage = 0.45
            case .moderatelyActive:
                carbPercentage = 0.50
            case .veryActive, .extraActive:
                carbPercentage = 0.55
        }
        
        
        if selectedGoal == .weightLoss { carbPercentage -= 0.05 }
        
        
        let caloriesForCarbs = targetCalories * carbPercentage
        let targetCarbs = caloriesForCarbs / 4
        
        
        let caloriesUsed = (targetProtein * 4) + (targetCarbs * 4)
        let remainingCalories = targetCalories - caloriesUsed
        
        let calculatedFat = remainingCalories / 9
        let minFat = weight * 0.5
        let targetFat = max(calculatedFat, minFat)
        
        
        self.proteinGoal = targetProtein
        self.carbsGoal = targetCarbs
        self.fatGoal = targetFat
        
        print("🎯 Gym strategy: \(Int(targetCalories)) kcal | P: \(Int(targetProtein))g | C: \(Int(targetCarbs))g | F: \(Int(targetFat))g")
    }
}
