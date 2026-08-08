//
//  FoodItem.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 13/11/25.
//

import SwiftData
import SwiftUI

@Model
class FoodItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Double
    var protein: Double
    var carbs: Double
    var fat: Double
    var servingQty: Double
    var servingUnit: String
    var photo: String?
    
    var iconName: String {
        let lowerUnit = servingUnit.lowercased()
        let lowerName = name.lowercased()
        
        if lowerUnit.contains("ml") {
            return "drop.fill"
        }
        
        if lowerName.contains("chicken") ||
            lowerName.contains("beef") ||
            lowerName.contains("steak") ||
            lowerName.contains("pork") ||
            lowerName.contains("meat") {
            return "fork.knife"
        }
        return "carrot.fill"
    }
    
    init(
        name: String,
         calories: Double,
         protein: Double,
         carbs: Double,
         fat: Double,
         servingQty: Double,
         servingUnit: String,
         photo: String? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.servingQty = servingQty
        self.servingUnit = servingUnit
        self.photo = photo
    }
    
    
}


