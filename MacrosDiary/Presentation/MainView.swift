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
    
    @Environment(\.modelContext) var context
    @StateObject private var profileViewModel = ProfileViewModel()
    
    var body: some View {
        TabView {
            Tab("Diary", systemImage: "book.closed") {
                DiaryView(modelContext: _context)
            }
            
            Tab("Stats", systemImage: "chart.bar") {
                StatsView(modelContext: context, profileViewModel: profileViewModel)
            }
            
            Tab("Profile", systemImage: "person.crop.circle") {
                ProfileView(viewModel: profileViewModel)
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
