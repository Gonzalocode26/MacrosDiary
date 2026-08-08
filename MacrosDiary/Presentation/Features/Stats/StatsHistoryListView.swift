//
//  HistoryListView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 29/1/26.
//

import SwiftUI
import SwiftData

struct StatsHistoryListView: View {
    @ObservedObject var viewModel: StatsViewModel
    let selectedStat: StatType
    
    var body: some View {
        ForEach(viewModel.filteredDays) { day in
            
            if !day.meals.flatMap({$0.foods}).isEmpty {
                
                Section {
                    ForEach(day.meals) { meal in
                        if !meal.foods.isEmpty {
                            
                            mealHeader(meal)

                            ForEach(meal.foods) { food in
                                
                                foodRow(food)
                            }
                            .onDelete { indexSet in
                                deleteFood(at: indexSet, from: meal)
                            }
                        }
                    }
                } header: {
                    dayHeader(day)
                }
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
            }
        }
    }

  // MARK: - Helper Views
  
  @ViewBuilder
  private func dayHeader(_ day: DiaryDay) -> some View {
      Text(day.date.formatted(.dateTime.weekday(.wide).day().month()))
          .font(.headline)
          .bold()
          .foregroundStyle(.primary)
          .padding(.horizontal)
          .padding(.top, 8)
          .textCase(nil)
  }
  
  @ViewBuilder
  private func mealHeader(_ meal: Meal) -> some View {
      Text(meal.type.capitalized)
          .font(.caption)
          .fontWeight(.heavy)
          .foregroundStyle(.purple)
          .listRowBackground(Color.clear)
          .listRowInsets(EdgeInsets(top: 15, leading: 20, bottom: 5, trailing: 0))
  }
  
  @ViewBuilder
  private func foodRow(_ food: FoodItem) -> some View {
      HStack {
          Text(food.name)
          Spacer()
          Text(food.formattedValue(for: selectedStat))
              .foregroundStyle(.secondary)
              .font(.caption)
      }
  }
  
  // MARK: - Actions
  
  private func deleteFood(at offsets: IndexSet, from meal: Meal) {
      for index in offsets {
          let foodToDelete = meal.foods[index]
          viewModel.deletefood(food: foodToDelete, meal: meal)
      }
  }
}

#Preview {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
  let vm = StatsViewModel(localContext: container.mainContext)
  
  return List {
      StatsHistoryListView(viewModel: vm, selectedStat: .calories)
  }
  .listStyle(.plain)
}
