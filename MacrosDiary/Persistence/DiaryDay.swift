//
//  DiaryDay.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 13/11/25.
//
import SwiftData
import SwiftUI

@Model
class DiaryDay {
    @Attribute(.unique) var id: UUID
    var date: Date
    var meals: [Meal]
    
    init (date: Date, meals: [Meal] = []) {
        self.id  = UUID()
        self.date = date
        self.meals = meals
    }
}
