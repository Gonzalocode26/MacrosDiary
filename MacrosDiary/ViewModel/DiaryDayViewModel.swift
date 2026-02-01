
//  DiaryDayViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 19/11/25.
//
import Foundation
import SwiftData
import Combine

@MainActor
class DiaryDayViewModel: ObservableObject {
    
    @Published var diaryDay: DiaryDay?
    
    var context: ModelContext
    
    init(localContext: ModelContext) {
        self.context = localContext
        loadOrCreateToday()
        
    }
    
    
    private func loadOrCreateToday() {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let descriptor = FetchDescriptor<DiaryDay>()
        let results = try? context.fetch(descriptor)
        
        if let existing = results?.first(where: { Calendar.current.isDate($0.date, inSameDayAs: todayStart) }) {
            self.diaryDay = existing
            ensureMealsExist(for: existing)
            return
        }
        let newDay = DiaryDay(date: todayStart, meals: [])
        
        ensureMealsExist(for: newDay)
        
        context.insert(newDay)
        
        do {
            try context.save()
            self.diaryDay = newDay
        } catch{
            print("DiarDayViewModel: Error saving DiaryDay: \(error)")
        }
    }
    
    
    private func ensureMealsExist(for day: DiaryDay) {
        let allMealTypes = MealType.allCases
        for mealType in allMealTypes {
            if !day.meals.contains(where: { $0.type == mealType.rawValue }) {
                let newMeal = Meal(type: mealType, foods: [])
                day.meals.append(newMeal)
            }
        }
    }
    
    
    func addFood(from details: FoodDetails, to mealType: MealType) {
        guard let day = diaryDay else { return }
        
        let newItem = FoodItem(from: details)
        
        if let meal = day.meals.first(where: { $0.type == mealType.rawValue }) {
            meal.foods.append(newItem)
            
            do {
                try context.save()
                print("✅ Saved: \(newItem.name) in \(mealType.rawValue)")
            } catch {
                print("Error saving meal: \(error)")
            }
        } else {
            print("Couldn't find the meal type: \(mealType.rawValue)")
        }
    }
    
    func deleteFood(_ food: FoodItem, meal: Meal) {
        if let index = meal.foods.firstIndex(where: {$0.id == food.id}) {
            meal.foods.remove(at: index)
        }
        context.delete(food)
        try? context.save()
    }
}
