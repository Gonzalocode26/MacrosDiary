//
//  ContentView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 6/10/25.
//

import SwiftUI

struct SearchView: View {
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchTextField = ""
    @StateObject private var viewModel = SearchViewModel()
    let selectedMeal: MealType?
    var onFoodSelected: ((FoodDetails) -> Void)?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12){
                Text("Macros Diary")
                    .font(Font.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.purple)
                    .padding()
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search an item", text: $searchTextField)
                        .focused($isSearchFieldFocused)
                        .onSubmit {
                            viewModel.hasSearched = true
                            viewModel.fetchFoods(query: searchTextField)
                        }
                        .textFieldStyle(.plain)
                }
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundStyle(.yellow)
                    Text(error)
                        .foregroundStyle(.red)
                        .padding()
                    Text("Please try again later")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if viewModel.searchResults.isEmpty {
                if viewModel.hasSearched {
                    VStack(spacing: 12) {
                        Image(systemName: "leaf")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)
                        Text("No results found")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        Text("Try searching for another food item")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                } else  {
                    EmptyView()
                }
            } else {
                List(viewModel.searchResults) { food in
                    NavigationLink(
                        destination: FoodDetailsView(
                            food: food,
                            onFoodSelected: onFoodSelected
                            )
                        ){
                            HStack {
                                if let url = food.mainImageUrl{
                                    AsyncImage(url: url) { image in
                                    image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    Image(systemName: "fork.knife.circle.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.purple)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(food.foodName)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .lineLimit(2)
                                    
                                    if let type = food.foodType {
                                        Text(type)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            isSearchFieldFocused = false
                        })
                    }
                    .listStyle(.inset)
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color(.systemGray6))
                }
            }
                .padding(.horizontal, 16)
                .background(Color.white)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isSearchFieldFocused = true
                    }
                }
        }
    }
    #Preview {
        SearchView(selectedMeal: nil)
    }
