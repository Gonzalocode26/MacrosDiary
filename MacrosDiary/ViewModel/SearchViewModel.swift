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
    
    @Published var searchResults: [FatSecretFood] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var hasSearched: Bool  = false
    
    private let service =  FatSecretFoodService()
    
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
                let results = try await service.searchFood(query: cleanedQuery)
                self.searchResults = results
            } catch {
                self.errorMessage = error.localizedDescription
                self.searchResults = []
            }
            isLoading = false
        }
    }
}
