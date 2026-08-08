//
//  MealRepositoryProtocol.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 30/07/2026.
//

import Foundation

@MainActor
protocol MealRepositoryProtocol {
    func getDay(date: Date) async throws -> DiaryDay
    func addFood(_ food: FoodDetails, to mealType: MealType, for diaryDay: DiaryDay) async throws
    func deleteFood(_ foodItem: FoodItem, from meal: Meal) async throws
    
}
