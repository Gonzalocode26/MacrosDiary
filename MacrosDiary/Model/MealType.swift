//
//  MealType.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 4/11/25.
//
import Foundation

enum MealType: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case snack = "Snack"
    case dinner = "Dinner"
        
    var id: String {rawValue}
}
