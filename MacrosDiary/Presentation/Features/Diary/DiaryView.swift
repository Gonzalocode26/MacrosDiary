
//  DiaryView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 18/10/25.
//

import SwiftUI
import SwiftData

struct DiaryView: View {
    let appContainer: AppContainer
    
    @StateObject private var viewModel: DiaryDayViewModel
    @State private var activeMealType: MealType?
    
    init(appContainer: AppContainer) {
        self.appContainer = appContainer
        _viewModel = StateObject(wrappedValue: DiaryDayViewModel(
            repository: appContainer.mealRepository,
            profileRepository: appContainer.userProfileRepository
        ))
    }
    
    var body: some View {
        DiaryContentView(appContainer: appContainer, viewModel: viewModel, activeMealType: $activeMealType)
    }
}

struct DiaryContentView: View {
    let appContainer: AppContainer
    
    @ObservedObject var viewModel: DiaryDayViewModel
    @Binding var activeMealType: MealType?
    
    var body: some View {
        NavigationStack{
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    
                    if let day = viewModel.diaryDay {
                        
                        let sortedMeals = day.meals.sorted {meal1, meal2 in
                            let idx1 = MealType.allCases.firstIndex(where:{ $0.rawValue == meal1.type }) ?? 0
                            let idx2 = MealType.allCases.firstIndex(where:{ $0.rawValue == meal2.type }) ?? 0
                            return idx1 < idx2
                        }
                        
                        ForEach(sortedMeals) { meal in
                            MealCard(meal: meal) {
                                if let type = MealType(rawValue: meal.type) {
                                    activeMealType = type
                                }
                            } onDelete: { foodItem in
                                Task { await viewModel.deleteFood(foodItem, meal: meal) }
                            }
                        }
                    } else {
                        ContentUnavailableView("Loading...", systemImage: "calendar")
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Diary")
            .sheet(item: $activeMealType) { type in
                SearchView(
                    selectedMeal: type,
                    appContainer: self.appContainer,
                    onFoodSelected: { foodDetails in
                        Task { await viewModel.addFood(from: foodDetails, to: type) }
                        activeMealType = nil
                    }
                )
            }
        }
        .background(Color(.systemGray6)).ignoresSafeArea()
        .task {
            await viewModel.loadOrCreateToday()
        }
    }
}

struct DailyProgressHeaderView: View {
    let progress: DailyProgress
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Calorías: \(Int(progress.consumedCalories)) / \(Int(progress.targetCalories)) kcal")
                .font(.headline)
            
            ProgressView(value: progress.caloriePercentage)
                .tint(.green)
            
            HStack {
                VStack {
                    Text("P: \(Int(progress.consumedProtein))g")
                    ProgressView(value: progress.proteinPercentage).tint(.red)
                }
                VStack {
                    Text("C: \(Int(progress.consumedCarbs))g")
                    ProgressView(value: progress.carbsPercentage).tint(.blue)
                }
                VStack {
                    Text("G: \(Int(progress.consumedFat))g")
                    ProgressView(value: progress.fatPercentage).tint(.yellow)
                }
            }
            .font(.caption)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    let mockAppContainer = AppContainer(modelContext: container.mainContext)
    
    DiaryView(appContainer: mockAppContainer)
        .modelContainer(container)
}

