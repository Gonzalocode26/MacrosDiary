//
//  ContentView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 6/10/25.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchTextField = ""
    @StateObject private var viewModel: SearchViewModel
    
    let selectedMeal: MealType?
    let appContainer: AppContainer
    var onFoodSelected: ((FoodDetails) -> Void)?
    
    init(selectedMeal: MealType?, appContainer: AppContainer, onFoodSelected: ((FoodDetails) -> Void)? = nil) {
        self.selectedMeal = selectedMeal
        self.appContainer = appContainer
        self.onFoodSelected = onFoodSelected
        self._viewModel = StateObject(wrappedValue: SearchViewModel(searchUseCase: appContainer.searchUseCase))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField(String(localized: "Search an item"), text: $searchTextField)
                            .focused($isSearchFieldFocused)
                            .submitLabel(.search)
                            .onSubmit {
                                if !searchTextField.isEmpty{
                                    viewModel.hasSearched = true
                                    viewModel.fetchFoods(query: searchTextField)
                                }
                            }
                        if !searchTextField.isEmpty {
                            Button{
                                searchTextField = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                
                ZStack {
                    Color(.systemGray6).ignoresSafeArea()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(error))
                    } else if viewModel.searchResults.isEmpty {
                        if viewModel.hasSearched {
                            ContentUnavailableView.search(text: searchTextField)
                        } else {
                            ContentUnavailableView("Add Food", systemImage: "fork.knife.circle.fill", description: Text("Try searching for another food item"))
                        }
                    } else {
                        List(viewModel.searchResults, id: \.id) { food in
                            ZStack {
                                NavigationLink(
                                    destination: FoodDetailsView(
                                        food: food,
                                        appContainer: self.appContainer,
                                        onFoodSelected: onFoodSelected
                                    )
                                ) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                FoodResultRow(food: food)
                            }
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .listRowSeparator(.hidden)
                        }
                        .padding(.vertical)
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                        .scrollContentBackground(.hidden)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(.horizontal)
            }
            .background(Color(.systemGray6))
            .navigationTitle(selectedMeal?.rawValue.capitalized ?? "Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isSearchFieldFocused = true
                }
            }
        }
    }
}

struct FoodResultRow: View {
    let food: FoodSearchResult
    
    var body: some View {
        HStack(spacing: 12) {
            if let urlString = food.imageUrl, let url = URL(string: urlString){
                AsyncImage(url: url) { phase in
                    if let image = phase.image{
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Color.gray.opacity(0.1)
                    }
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable().scaledToFit()
                    .padding(12)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.purple)
                    .background(Color.purple.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                if let type = food.type {
                    Text(type.capitalized)
                        .font(.caption2)
                        .foregroundStyle(.blue)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MockFoodCatalog: FoodCatalogProtocol {
    func foodSearchResult(query: String) async throws -> [FoodSearchResult] {
        return [
            FoodSearchResult(id: "1", name: "Fake chicken", type: "generic", imageUrl: nil)
        ]
    }
    
    func getFood(id: String) async throws -> FoodDetails {
        let fakeServing = [ FoodServing(id: "1", description: "Fake chicken", amount: 100, unit: "g", calories: 120, carbs: 0, protein: 30, fat: 5, cholesterol: 0, sodium: 40, sugar: 0, fiber: 10)
        ]
        
        return FoodDetails(id: "1", name: "Fake chicken", photoURL: nil, servings: fakeServing)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    let mockAppContainer = AppContainer(modelContext: container.mainContext)
    
    return SearchView(selectedMeal: nil, appContainer: mockAppContainer)
}
