//
//  AppContainer.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 07/08/2026.
//

import Foundation
import SwiftData

@MainActor
final class AppContainer {
    let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Services & Catalogs
    
    lazy var translationService: TranslationServiceProtocol = DeepLTranslationService()
    lazy var foodCatalog: FoodCatalogProtocol = FatSecretFoodCatalog()
    
    // MARK: - Repositories
    
    lazy var mealRepository: MealRepositoryProtocol = MealRepository(context: modelContext)
    lazy var userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()
    
    // MARK: - Use Cases
    
    lazy var searchUseCase: SearchFoodUseCase = {
        SearchFoodUseCase(catalog: foodCatalog, translator: translationService)
    }()
}
