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
    let container: ModelContainer
    let appContainer: AppContainer
    
    init() {
        do {
            container = try ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self)
            appContainer = AppContainer(modelContext: container.mainContext)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView(appContainer: appContainer)
        }
        .modelContainer(container)
    }
}
