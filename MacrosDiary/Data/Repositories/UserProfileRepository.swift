//
//  UserProfileRepository.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 02/08/2026.
//

import Foundation

class UserProfileRepository: UserProfileRepositoryProtocol {
    func loadProfile() -> ProfileData {
        let userDefaults = UserDefaults.standard
        
        let defaultName = userDefaults.string(forKey: "user_name") ?? "User"
        let defaultGender = userDefaults.string(forKey: "user_gender") ?? "Male"
        let defaultAge = userDefaults.integer(forKey: "user_age") != 0 ? userDefaults.integer(forKey: "user_age") : 25
        let defaultHeight = userDefaults.double(forKey: "user_height") != 0 ? userDefaults.double(forKey: "user_height") : 180
        let defaultWeight = userDefaults.double(forKey: "user_weight") != 0 ? userDefaults.double(forKey: "user_weight") : 80
        let defaultActivity = userDefaults.double(forKey: "user_activity") != 0 ? userDefaults.double(forKey: "user_activity") : 1.55
        let defaultGoal = userDefaults.string(forKey: "user_goal") ?? "Maintenance"
        let defaultIsAutoCalculate = userDefaults.bool(forKey: "user_isAutoCalculate")
        let defaultCalories = userDefaults.double(forKey: "calorie_target") != 0 ? userDefaults.double(forKey: "calorie_target") : 2000
        let defaultProtein = userDefaults.double(forKey: "protein_target") != 0 ? userDefaults.double(forKey: "protein_target") : 120
        let defaultCarbs = userDefaults.double(forKey: "carbs_target") != 0 ? userDefaults.double(forKey: "carbs_target") : 200
        let defaultFat = userDefaults.double(forKey: "fat_target") != 0 ?userDefaults.double(forKey: "fat_target") : 60
        
        let userProfile = UserProfile(name: defaultName, gender: Gender(rawValue: defaultGender) ?? .male, age: defaultAge, height: defaultHeight, weight: defaultWeight, activityLevel: ActivityLevel(rawValue: defaultActivity) ?? .moderatelyActive, goal: GoalType(rawValue: defaultGoal) ?? .maintenance, isAutoCalculate: defaultIsAutoCalculate)
        
        let macroTarget = MacroTarget(calories: defaultCalories, protein: defaultProtein, carbs: defaultCarbs, fat: defaultFat)
        
        return ProfileData(profile: userProfile, target: macroTarget)
        
    }
    
    func saveProfile(_ data: ProfileData) {
        let defaults = UserDefaults.standard
        
        defaults.set(data.profile.name, forKey: "user_name")
        defaults.set(data.profile.gender.rawValue, forKey: "user_gender")
        defaults.set(data.profile.age, forKey: "user_age")
        defaults.set(data.profile.height, forKey: "user_height")
        defaults.set(data.profile.weight, forKey: "user_weight")
        defaults.set(data.profile.activityLevel.rawValue, forKey: "user_activity")
        defaults.set(data.profile.goal.rawValue, forKey: "user_goal")
        defaults.set(data.profile.isAutoCalculate, forKey: "user_isAutoCalculate")
        defaults.set(data.target.calories, forKey: "calorie_target")
        defaults.set(data.target.protein, forKey: "protein_target")
        defaults.set(data.target.carbs, forKey: "carbs_target")
        defaults.set(data.target.fat, forKey: "fat_target")
    }
}
