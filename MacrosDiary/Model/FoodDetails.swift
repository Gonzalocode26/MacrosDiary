//
//  FoodDetails.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 14/10/25.
//

import Foundation

struct FoodDetails: Identifiable, Hashable {
    let id: String
    let name: String
    let calories: Double
    let protein: Double
    let fat: Double
    let carbs: Double
    let servingSize: Double
    let servingUnit: String
    let photoURL: URL?
}
