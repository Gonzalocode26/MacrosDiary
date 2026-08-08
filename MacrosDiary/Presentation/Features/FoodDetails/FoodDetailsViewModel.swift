//
//  FoodDetailsViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 22/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class FoodDetailsViewModel: ObservableObject {
    private let catalog: FoodCatalogProtocol
    let searchresult: FoodSearchResult
    
    @Published var fullDetails: FoodDetails? = nil
    @Published var userEnteredAmount: Double = 1.0
    @Published var selectedServing: FoodServing? {
        didSet {
            userEnteredAmount = selectedServing?.amount ?? 1.0
        }
    }
    
    var multiplier: Double {
        let baseAmount = selectedServing?.amount ?? 1.0
        guard baseAmount > 0 else { return 1.0 }
        
        return userEnteredAmount / baseAmount
    }
    
    init(catalog: FoodCatalogProtocol, searchresult: FoodSearchResult) {
        self.catalog = catalog
        self.searchresult = searchresult
    }
    
    // MARK: - MACROS
    
    var currentCalories: Double { (selectedServing?.calories ?? 0) * multiplier }
    var currentProtein: Double { (selectedServing?.protein ?? 0) * multiplier }
    var currentCarbohydrates: Double { (selectedServing?.carbs ?? 0) * multiplier }
    var currentFats: Double { (selectedServing?.fat ?? 0) * multiplier }
    var currentCholesterol: Double { (selectedServing?.cholesterol ?? 0) * multiplier }
    var currentSodium: Double { (selectedServing?.sodium ?? 0) * multiplier }
    var currentSugar: Double { (selectedServing?.sugar ?? 0) * multiplier }
    var currentFiber: Double { (selectedServing?.fiber ?? 0) * multiplier }
    
    var macroDistribution: [MacroData] {
        return [
            MacroData(type: .carbs, value: currentCarbohydrates),
            MacroData(type: .protein, value: currentProtein),
            MacroData(type: .fat, value: currentFats)
        ]
    }
    
    // MARK: - LOAD & CREATE DETAILS
    
    func loadDetails() async  {
        do {
            let details = try await catalog.getFood(id: searchresult.id)
            
            withAnimation {
                self.fullDetails = details
                self.selectedServing = details.servings.first
            }
        }
        catch {
            print("Error loading deatils: \(error.localizedDescription)")
        }
    }
    
    func createFoodDetails() -> FoodDetails {
        let savedServing = FoodServing(
            id: selectedServing?.id ?? "0",
            description: selectedServing?.description ?? "Custom",
            amount: userEnteredAmount,
            unit: selectedServing?.unit ?? "unit",
            calories: currentCalories,
            carbs: currentCarbohydrates,
            protein: currentProtein,
            fat: currentFats,
            cholesterol: currentCholesterol,
            sodium: currentSodium,
            sugar: currentSugar,
            fiber: currentFiber
        )
        
        return FoodDetails(
            id: searchresult.id,
            name: searchresult.name,
            photoURL: fullDetails?.photoURL,
            servings: [savedServing]
        )
    }
}

struct MacroData: Identifiable {
    let id = UUID()
    let type: StatType
    let value: Double
}
