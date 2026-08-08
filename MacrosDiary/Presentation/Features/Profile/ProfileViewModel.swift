//
//  ProfileViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 21/1/26.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    let repository: UserProfileRepositoryProtocol
    
    @Published var name: String = ""
    @Published var gender: Gender = .male
    @Published var age: Int = 0
    @Published var height: Double = 0
    @Published var weight: Double = 0
    @Published var activityLevel: ActivityLevel = .moderatelyActive
    @Published var goal: GoalType = .maintenance
    @Published var isAutoCalculate: Bool = false
    @Published var calorieTarget: Double = 0
    @Published var proteinTarget: Double = 0
    @Published var carbsTarget: Double = 0
    @Published var fatTarget: Double = 0
    
    
    init(repository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.repository = repository
        let data = repository.loadProfile()
        
        self.name = data.profile.name
        self.gender = data.profile.gender
        self.age = data.profile.age
        self.height = data.profile.height
        self.weight = data.profile.weight
        self.activityLevel = data.profile.activityLevel
        self.goal = data.profile.goal
        self.isAutoCalculate = data.profile.isAutoCalculate
        self.calorieTarget = data.target.calories
        self.proteinTarget = data.target.protein
        self.carbsTarget = data.target.carbs
        self.fatTarget = data.target.fat
    }
    
    func save() {
        let userProfile = UserProfile(
            name: name,
            gender: gender,
            age: age,
            height: height,
            weight: weight,
            activityLevel: activityLevel,
            goal: goal,
            isAutoCalculate: isAutoCalculate
        )
        
        let finalTarget: MacroTarget
        
        if userProfile.isAutoCalculate {
            let calculatedTarget = MacroCalculator.calculate(for: userProfile)
            
            self.calorieTarget = calculatedTarget.calories
            self.proteinTarget = calculatedTarget.protein
            self.carbsTarget = calculatedTarget.carbs
            self.fatTarget = calculatedTarget.fat
            
            finalTarget = calculatedTarget
        } else {
            finalTarget = MacroTarget(
                calories: calorieTarget,
                protein: proteinTarget,
                carbs: carbsTarget,
                fat: fatTarget
            )
        }
        let profiledata = ProfileData(profile: userProfile, target: finalTarget)
        
        repository.saveProfile(profiledata)
    }
}
