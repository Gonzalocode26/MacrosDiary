//
//  SearchFoodUseCaseTests.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 07/09/2026.
//

import XCTest
@testable import MacrosDiary

@MainActor
final class SearchFoodUseCaseTests: XCTestCase {
    func test_search_whenTranslationFails_returnsOriginalEnglishFood() async throws {
        // 1. ARRANGE
        let mockFoodCatalog = MockFoodCatalog()
        let failingTranslationService = FailingTranslationServiceMock()
        
        let sut = SearchFoodUseCase(
            catalog: mockFoodCatalog,
            translator: failingTranslationService,
            languageCode: "es"
        )
        
        // 2. ACT
        let results = try await sut.execute(query: "Pollo")
        
        // 3. ASSERT
        XCTAssertFalse(results.isEmpty, "Result should'nt be an empty array if translation fails.")
        XCTAssertEqual(results.first?.name, "Fake chicken", "Result should be in English if DeepL explodes")
    }
}

class FailingTranslationServiceMock: TranslationServiceProtocol {
    func translate(text: String, targetLanguage: String) async throws -> String {
        throw URLError(.notConnectedToInternet)
    }
}



struct MockFoodCatalog: FoodCatalogProtocol {
    func foodSearchResult(query: String) async throws -> [FoodSearchResult] {
        return [
            FoodSearchResult(id: "1", name: "Fake chicken", type: "generic", imageUrl: nil)
        ]
    }
    
    func getFood(id: String) async throws -> FoodDetails {
        let fakeServing = [ FoodServing(id: "1", description: "Fake chicken", amount: 100, unit: "g", calories: 120, carbs: 0, protein: 30, fat: 5, cholesterol: 0, sodium: 40, sugar: 0, fiber: 10)
        ]
        
        return FoodDetails(id: "1", name: "Fake chicken", photoURL: nil, servings: fakeServing)
    }
}
