//
//  MealRepository.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 30/07/2026.
//

import Foundation
import SwiftData

@MainActor
class MealRepository: MealRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Private helpers
    
    private func ensureMealsExist(for day: DiaryDay) {
        let allMealTypes = MealType.allCases
        for mealType in allMealTypes {
            if !day.meals.contains(where: { $0.type == mealType.rawValue }) {
                let newMeal = Meal(type: mealType, foods: [])
                day.meals.append(newMeal)
            }
        }
    }
    
    func getDay(date: Date) async throws -> DiaryDay {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let descriptor = FetchDescriptor<DiaryDay>()
        let results = try context.fetch(descriptor)
        
        if let existing = results.first(where: { Calendar.current.isDate($0.date, inSameDayAs: startOfDay) }) {
            ensureMealsExist(for: existing)
            return existing
        }
        
        let newDay = DiaryDay(date: startOfDay, meals: [])
        ensureMealsExist(for: newDay)
        
        context.insert(newDay)
        try context.save()
        
        return newDay
    }
    
    func addFood(_ food: FoodDetails, to mealType: MealType, for diaryDay: DiaryDay) async throws {
        guard let savedServing = food.servings.first else { return }
        
        let newItem = FoodItem(
            name: food.name,
            calories: savedServing.calories,
            protein: savedServing.protein,
            carbs: savedServing.carbs,
            fat: savedServing.fat,
            servingQty: savedServing.amount,
            servingUnit: savedServing.unit,
            photo: food.photoURL?.absoluteString
        )
        
        if let meal = diaryDay.meals.first(where: { $0.type == mealType.rawValue }) {
            meal.foods.append(newItem)
            
            do {
                try context.save()
                
                print("Saved: \(newItem.name) in \(mealType.rawValue)")
            } catch {
                print("Error saving meal: \(error)")
            }
        } else {
            print("Couldn't find the meal type: \(mealType.rawValue)")
        }
    }
    
    func deleteFood(_ foodItem: FoodItem, from meal: Meal) async throws {
        context.delete(foodItem)
        
        try? context.save()
    }
}
