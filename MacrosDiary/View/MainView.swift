//
//  MainView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 18/10/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var context
    @StateObject private var profileViewModel = ProfileViewModel()
    var body: some View {
        TabView {
            Tab("Diary", systemImage: "book.closed") {
                DiaryView(modelContext: context)
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
    
  return MainView()
        .modelContainer(container)
}
