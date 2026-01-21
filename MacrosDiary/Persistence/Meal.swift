//
//  Meal.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 13/11/25.
//

import SwiftUI
import SwiftData

@Model
class Meal: Identifiable {
    @Attribute(.unique) var id = UUID()
    var type: String
    var foods: [FoodItem]

    init(type: MealType, foods: [FoodItem] = []) {
        self.type = type.rawValue
        self.foods = foods
}
}
