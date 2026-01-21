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
    
    init(from details : FoodDetails)
    {
        self.id = UUID()
        self.name = details.name
        self.calories = details.calories
        self.protein = details.protein
        self.carbs = details.carbs
        self.fat = details.fat
        self.servingQty = details.servingSize
        self.servingUnit = details.servingUnit
        self.photo = details.photoURL?.absoluteString
    }
    
    
}


