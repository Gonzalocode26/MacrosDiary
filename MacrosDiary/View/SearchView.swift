//
//  ContentView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 6/10/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchTextField = ""
    @StateObject private var viewModel = SearchViewModel()
    
    let selectedMeal: MealType?
    var onFoodSelected: ((FoodDetails) -> Void)?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                VStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Search an item", text: $searchTextField)
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
                        List(viewModel.searchResults, id: \.foodId) { food in
                            ZStack {
                                NavigationLink(
                                    destination: FoodDetailsView(
                                        food: food,
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
                .padding((.horizontal))
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
    let food: FatSecretFood
    var body: some View {
        HStack(spacing: 12) {
            if let url = food.mainImageUrl{
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
                Text(food.foodName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                
                if let type = food.foodType {
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

#Preview {
    SearchView(selectedMeal: nil)
}
