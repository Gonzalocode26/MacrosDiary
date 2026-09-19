//
//  MainView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 18/10/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    let appContainer: AppContainer
    
    
    var body: some View {
        TabView {
            Tab("Diary", systemImage: "book.closed") {
                DiaryView(appContainer: appContainer)
            }
            
            Tab("Stats", systemImage: "chart.bar") {
                StatsView(appContainer: appContainer)
            }
            
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView(appContainer: appContainer)
            }
        }
        .tint(Color.purple)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    let mockAppContainer = AppContainer(modelContext: container.mainContext)
    
    return MainView(appContainer: mockAppContainer)
            .modelContainer(container)
}
