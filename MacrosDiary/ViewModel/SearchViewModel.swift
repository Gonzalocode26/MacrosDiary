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
        //This is to clean the query from white spaces.
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
    
//    private func handleError(_ error: Error) -> String {
//        if let netError = error as? NetworkError {
//            switch netError {
//                case .invalidUrl:
//                    return "❌ Invalid URL"
//                case .invalidResponse:
//                    return "❌ Invalid server response"
//                case .httpError(statusCode: let code, _):
//                    return "❌ Server Error: \(code)"
//                case .noData:
//                    return "❌ No data found"
//                case .decodingError:
//                    return "❌ Failed to decode data"
//                case .requestFailed(let e):
//                    return "❌ Conection failed: \(e.localizedDescription)"
//            }
//        }
//        return "❌ Unknown error: \(error.localizedDescription)"
//    }
    
}
