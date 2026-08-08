//
//  FoodDetails.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 14/10/25.
//

import Foundation

struct FoodServing: Identifiable, Hashable, Sendable {
    let id: String
    let description: String
    let amount: Double
    let unit: String
    let calories: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    let cholesterol: Double
    let sodium: Double
    let sugar: Double
    let fiber: Double
}

struct FoodDetails: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let photoURL: URL?
    let servings: [FoodServing]
}
