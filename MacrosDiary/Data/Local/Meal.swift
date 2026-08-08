//
//  Meal.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 13/11/25.
//

import SwiftUI
import SwiftData

@Model
class Meal {
    var id = UUID()
    var type: String
    
    @Relationship(deleteRule: .cascade)
    var foods: [FoodItem]

    init(type: MealType, foods: [FoodItem] = []) {
        self.id = UUID()
        self.type = type.rawValue
        self.foods = foods
}
}
