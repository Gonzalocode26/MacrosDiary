//
//  DiaryDayViewModelTests.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 07/09/2026.
//

import XCTest
import SwiftData
@testable import MacrosDiary

@MainActor
final class DiaryDayViewModelTests: XCTestCase {
    var container: ModelContainer!
    var sut: DiaryDayViewModel!
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
        
        let mealRepository = MealRepository(context: container.mainContext)
        let profileRepository = UserProfileRepository()
        
        sut = DiaryDayViewModel(repository: mealRepository, profileRepository: profileRepository)
        await sut.loadOrCreateToday()
    }
    
    override func tearDown() async throws {
        sut = nil
        container = nil
    }
    
    func test_addFood_updatesDailyProgressCalories() async throws {
        // 1. ARRANGE
        let mockServing = FoodServing(id: "1", description: "Test", amount: 100, unit: "g", calories: 250, carbs: 20, protein: 10, fat: 5, cholesterol: 0, sodium: 0, sugar: 0, fiber: 0)
        let mockFoodDetails = FoodDetails(id: "1", name: "Manzana", photoURL: nil, servings: [mockServing])
        
        // 2. ACT
        await sut.addFood(from: mockFoodDetails, to: .breakfast)
        
        // 3. ASSERT
        XCTAssertEqual(sut.dailyProgress?.consumedCalories, 250.0)
    }
}
