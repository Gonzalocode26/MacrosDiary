//
//  SearchFoodUseCase.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 07/08/2026.
//

import Foundation

struct SearchFoodUseCase {
    private let catalog: FoodCatalogProtocol
    private let translator: TranslationServiceProtocol
    private let currentLanguageCode: String
    
    init(catalog: FoodCatalogProtocol, translator: TranslationServiceProtocol, languageCode: String = Locale.current.language.languageCode?.identifier.lowercased() ?? "en") {
        self.catalog = catalog
        self.translator = translator
        self.currentLanguageCode = languageCode
    }
    
    func execute (query: String) async throws -> [FoodSearchResult] {
        if currentLanguageCode.hasPrefix("en") {
            return try await catalog.foodSearchResult(query: query)
        }
        
        let englishQuery = try await translator.translate(text: query, targetLanguage: "EN-US")
        let englishResults = try await catalog.foodSearchResult(query: englishQuery)
        let targetDeepLLang = currentLanguageCode.uppercased()
        
        return await withTaskGroup(of: FoodSearchResult.self) { group in
            var translatedResults: [FoodSearchResult] = []
            
            for item in englishResults {
                group.addTask {
                    
                    do {
                        let translatedName = try await translator.translate(text: item.name, targetLanguage: targetDeepLLang)
                        
                        return FoodSearchResult(id: item.id, name: translatedName, type: item.type, imageUrl: item.imageUrl)
                    } catch {
                        return item
                    }
                }
            }
            
            for await result in group {
                translatedResults.append(result)
            }
            
            return translatedResults
        }
    }
}
