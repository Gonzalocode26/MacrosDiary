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
    
    private let service = FatSecretFoodService()
    
    let food: FatSecretFood
    
    @Published var selectedServing: FatSecretServing? {
        didSet {
            resetAmount()
        }
    }
    
    @Published var userEnteredAmount: Double = 1.0
    
    @Published var highQualityUrl: URL?
    
    init(food: FatSecretFood) {
        self.food = food
        self.selectedServing = food.servings?.serving.first(where: {$0.metricServingUnit == "g"})
        ?? food.servings?.serving.first
        self.highQualityUrl = food.mainImageUrl
        resetAmount()
    }
    
    var isWeightBased: Bool {
        let desc = selectedServing?.servingDescription.lowercased() ?? ""
        return desc.contains("100 g") || desc.contains("100 ml") || desc.contains("oz")
    }
    
    var displayUnit: String {
        let desc = selectedServing?.servingDescription.lowercased() ?? ""
        if desc.contains("oz") { return "oz"}
        if desc.contains("100 ml") { return "ml"}
        if desc.contains("100 g") || selectedServing?.metricServingUnit == "g" { return "g"}
        
        return ""
    }
    
    func formatServingLabel(_ serving: FatSecretServing) -> String {
        let desc = serving.servingDescription.lowercased()
        
        
        if desc.contains("extra large") { return "Extra Large"}
        if desc.contains("extra small") { return "Extra Small"}
        if desc.contains("large") { return "Large"}
        if desc.contains("medium") { return "Medium"}
        if desc.contains("small") { return "Small"}
        
        
        if desc.contains("cup") { return "Cup"}
        if desc.contains("tablespoon") { return "Tablespoon"}
        if desc.contains("teaspoon") { return "Teaspoon"}
        if desc.contains("oz") { return "Ounces (oz)"}
        if desc.contains("Slice") { return "Slice"}
        
        
        if desc.contains("100 g") { return "Grams (g)"}
        if desc.contains("100 ml") { return "Mililiters (ml)"}
        
        
        var clean = serving.servingDescription
        if clean.hasPrefix("1 ") {
            clean = String(clean.dropFirst(2))
        }
        if let parenthesisIndex = clean.firstIndex(of: "(") {
            clean = String(clean[..<parenthesisIndex]).trimmingCharacters(in: .whitespaces)
        }
        
        return clean.prefix(1).capitalized + clean.dropFirst()
    }
    
    private var baseAmount: Double {
        if isWeightBased {
            let desc = selectedServing?.servingDescription ?? ""
            if desc.contains("100 g") || desc.contains("100 ml") { return 100.0}
            if desc.contains("oz") { return 1.0}
        }
        return 1.0
    }
    
    private func resetAmount() {
        self.userEnteredAmount = baseAmount
    }
    
    var multiplier: Double {
        return userEnteredAmount / baseAmount
    }
    
    //Macros
    var currentCalories: Double {
        (selectedServing?.caloriesValue ?? 0) * multiplier
    }
    var currentProtein: Double {
        (selectedServing?.proteinValue ?? 0) * multiplier
    }
    var currentCarbohydrates: Double {
        (selectedServing?.carbohydrateValue ?? 0) * multiplier
    }
    var currentFats: Double {
        (selectedServing?.fatValue ?? 0) * multiplier
    }
    var currentCholesterol: Double {
        (selectedServing?.cholesterolValue ?? 0) * multiplier
    }
    var currentSodium: Double {
        (selectedServing?.sodiumValue ?? 0) * multiplier
    }
    var currentSugar: Double {
        (selectedServing?.sugarValue ?? 0) * multiplier
    }
    var currentFiber: Double {
        (selectedServing?.fiberValue ?? 0) * multiplier
    }
    
    var macroDistribution: [MacroData] {
        return [
            MacroData(type: .carbs, value: currentCarbohydrates),
            MacroData(type: .protein, value: currentProtein),
            MacroData(type: .fat, value: currentFats)
        ]
    }
    
    func createFoodDetails() -> FoodDetails {
        var unitName = displayUnit
        
        if isWeightBased {
            unitName = formatServingLabel(selectedServing!)
        }
        return FoodDetails(
            id: food.id,
            name: food.foodName,
            calories: currentCalories,
            protein: currentProtein,
            fat: currentFats,
            carbs: currentCarbohydrates,
            servingSize: userEnteredAmount,
            servingUnit: unitName,
            photoURL: food.mainImageUrl)
    }
    func loadHighQualityImage() async  {
        do {
            if let fullDetails = try await service.getFood(id: food.id) {
//                print("Details reeceived. Image?:  \(fullDetails.mainImageUrl?.absoluteString ?? "NO")")
                print("🔍 Test - Image URL: \(fullDetails.mainImageUrl?.absoluteString ?? "nil")")
                if let newUrl = fullDetails.mainImageUrl {
                    withAnimation {
                        self.highQualityUrl = newUrl
                    }
                }
            }
        }
        catch {
            print("Error loading image: \(error)")
        }
    }
}

struct MacroData: Identifiable {
    let id = UUID()
    let type: StatType
    let value: Double
}
