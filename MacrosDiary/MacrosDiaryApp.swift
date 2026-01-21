//
//  MacrosDiaryApp.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 6/10/25.
//

import SwiftUI
import SwiftData

@main
struct MacrosDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [DiaryDay.self, Meal.self, FoodItem.self])
    }
}
