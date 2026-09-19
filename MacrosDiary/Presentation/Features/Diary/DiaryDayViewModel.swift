
//  DiaryDayViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 19/11/25.
//

import Foundation
import Combine

@MainActor
class DiaryDayViewModel: ObservableObject {
    private let repository: MealRepositoryProtocol
    private let profileRepository: UserProfileRepositoryProtocol
    
    @Published var diaryDay: DiaryDay?
    @Published var dailyProgress: DailyProgress?
    
    init(
        repository: MealRepositoryProtocol,
        profileRepository: UserProfileRepositoryProtocol
    ) {
        self.repository = repository
        self.profileRepository = profileRepository
    }
    
    func loadOrCreateToday() async {
        do {
            self.diaryDay = try await repository.getDay(date: Date())
            
            calculateProgress()
        }  catch {
            print("Error loading day: \(error)")
        }
    }
    
    func addFood(from details: FoodDetails, to mealType: MealType) async {
        guard let day = diaryDay else { return }
        
        do {
            try await repository.addFood(details, to: mealType, for: day)
            
            calculateProgress()
        } catch {
            print("Error adding food: \(error)")
        }
    }
    
    func deleteFood(_ food: FoodItem, meal: Meal) async {
        do {
            try await repository.deleteFood(food, from: meal)
            
            calculateProgress()
        } catch {
            print("Error deleting food: \(error)")
        }
    }
    
    func calculateProgress() {
        guard let day = diaryDay else { return }
        
        let allFoods = day.meals.flatMap { $0.foods}
        let totalCalories = allFoods.reduce(0.0) { $0 + $1.calories }
        let totalProtein = allFoods.reduce(0.0) { $0 + $1.protein }
        let totalCarbs = allFoods.reduce(0.0) { $0 + $1.carbs }
        let totalFat = allFoods.reduce(0.0) { $0 + $1.fat }
        
        let profileData = profileRepository.loadProfile()
        
        let progress = ProgressCalculator.calculate(
            consumedCalories: totalCalories,
            consumedProtein: totalProtein,
            consumedCarbs: totalCarbs,
            consumedFat: totalFat,
            target: profileData.target
        )
        
        self.dailyProgress = progress
    }
}
