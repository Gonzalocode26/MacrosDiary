//
//  FoodViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 8/10/25.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    private let searchUseCase: SearchFoodUseCase
    
    @Published var searchResults: [FoodSearchResult] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasSearched: Bool  = false
    
    init(searchUseCase: SearchFoodUseCase) {
        self.searchUseCase = searchUseCase
    }
    
    func fetchFoods(query: String) {
        
        let cleanedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanedQuery.isEmpty else {
            self.searchResults = []
            return
        }
        isLoading = true
        errorMessage = nil
        hasSearched = true
        
        Task {
            do {
                let results = try await searchUseCase.execute(query: cleanedQuery)
                self.searchResults = results
            } catch {
                self.errorMessage = error.localizedDescription
                self.searchResults = []
            }
            isLoading = false
        }
    }
}
