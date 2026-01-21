//
//  StatsView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 23/12/25.
//

import SwiftUI
import Charts
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) var context
    @StateObject private var viewModel: StatsViewModel
    @State private var selectedStat: StatType = .calories
    
    @AppStorage("calorie_goal") private var calorieGoal: Double = 2000
    @AppStorage("protein_goal") private var proteinGoal: Double = 150
    @AppStorage("carbs_goal") private var carbsGoal: Double = 250
    @AppStorage("fat_goal") private var fatGoal: Double = 60
    
    var isCurrentWeek: Bool {
        /*This is code
         if Calendar.current.isDate(viewModel.currentWeekStart, equalTo: Date(), toGranularity: .weekOfYear) {return true} else {return false}
         */
        return Calendar.current.isDate(viewModel.currentWeekStart, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    init(modelContext: ModelContext) {
        let vm = StatsViewModel(localContext: modelContext)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationStack {
            List{
                Section {
                    VStack(spacing: 20){
                        Picker("Stat", selection: $selectedStat) {
                            ForEach(StatType.allCases, id: \.self) { type in
                                Text(type.rawValue.capitalized).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        HStack{
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 20))
                                .onTapGesture {
                                    viewModel.changeWeek(by: -1)
                                }
                                .foregroundStyle(.purple)
                            Spacer()
                            Text(viewModel.weekRangeString)
                                .frame(minWidth: 150)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Image(systemName: "chevron.forward")
                                .font(.system(size: 20))
                                .onTapGesture {
                                    viewModel.changeWeek(by: 1)
                                }
                                .foregroundStyle(isCurrentWeek ? .gray.opacity(0.7) : .purple)
                                .disabled(isCurrentWeek)
                            //                    .disabled(Calendar.current.isDate(viewModel.currentWeekStart, equalTo: Date(), toGranularity: .weekOfYear))
                        }
                        .padding(.horizontal)
                        
                        ChartView(weeklyData: viewModel.weeklyData, selectedStat: selectedStat, goal: getGoal())
                            .frame(height: 200)
                            .padding(.horizontal)
                        
                        dayFilterSection
                            .padding(.bottom, 8)
                    }
                    .background(Color.white)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                //                List {
                //                    1st loop for the days of the week. Reversed to show the latest first
                ForEach(viewModel.filteredDays) { day in
                    
                    if !day.meals.flatMap({$0.foods}).isEmpty {
                        
                        Section {
                            //2nd loop is for the meals in every "day" (variable of the 1st loop)
                            ForEach(day.meals) { meal in
                                if !meal.foods.isEmpty {
                                    Text(meal.type.capitalized)
                                        .font(.caption)
                                        .fontWeight(.heavy)
                                        .foregroundStyle(.purple)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(EdgeInsets(top: 15, leading: 20, bottom: 5, trailing: 0))
                                    
                                    //Loop of every "food" (FoodItem). Includes macros and info
                                    ForEach(meal.foods) { food in
                                        HStack{
                                            Text(food.name)
                                            Spacer()
                                            Text(formatSelection(foodItem: food))
                                                .foregroundStyle(.secondary)
                                                .font(.caption)
                                        }
                                    }
                                    .onDelete { indexSet in
                                        deleteFood(at: indexSet, from: meal)
                                    }
                                }
                            }
                        } header: {
                            Text(day.date.formatted(.dateTime.weekday(.wide).day().month()))
                                .font(.headline).bold()
                                .foregroundStyle(.primary)
                                .padding(.horizontal)
                                .padding(.top, 8)
                                .textCase(nil)
                        }
                        .listSectionSeparator(.hidden)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchWeeklyDays()
            }
        }
    }
    
    var dayFilterSection: some View {
        VStack(spacing: 4) {
            Text("History")
                .font(.subheadline)
                .fontWeight(.bold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    let isAllSelected = (viewModel.selectedDate == nil)
                    Button {
                        withAnimation { viewModel.selectedDate = nil }
                    } label: {
                        Text("All")
                            .font(.system(size: 14))
                            .fontWeight(isAllSelected ? .semibold : .regular)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(isAllSelected ? Color.purple : Color.gray.opacity(0.1))
                            .foregroundStyle(isAllSelected ? .white : .primary)
                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(.purple, lineWidth: isAllSelected ? 0 : 1))
                    }
                    .buttonStyle(.plain)
                    
                    ForEach(0..<7, id: \.self) { index in //This for each goes from 0 -> Monday to 6 Sunday
                        let date = Calendar.current.date(byAdding: .day, value: index, to: viewModel.currentWeekStart)!
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate ?? Date.distantPast)
                        
                        Button {
                            withAnimation{ viewModel.selectedDate = date }
                        } label: {
                            Text(date.formatted(.dateTime.weekday(.wide)))
                                .font(.system(size: 14))
                                .fontWeight(isSelected ? .semibold : .regular)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(isSelected ? Color.purple : Color.gray.opacity(0.1))
                                .foregroundStyle(isSelected ? .white : .primary)
                                .clipShape(Capsule())
//                                .overlay(Capsule().stroke(.purple, lineWidth: isSelected ? 0 : 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
    
    private func deleteFood(at offsets: IndexSet, from meal: Meal) {
        for index in offsets {
            let foodToDelete = meal.foods[index]
            viewModel.deletefood(food: foodToDelete, meal: meal)
        }
    }
    
    private func formatSelection(foodItem: FoodItem) -> String {
        switch selectedStat {
            case .calories: return "\(Int(foodItem.calories)) kcal"
            case .protein: return  String(format: "%.1f g", foodItem.protein)
            case .carbs: return String(format: "%.1f g", foodItem.carbs)
            case .fat: return String(format: "%.1f g", foodItem.fat)
        }
    }
    func getGoal() -> Double {
        switch selectedStat {
            case .calories:  return calorieGoal
            case .protein:   return proteinGoal
            case .carbs:     return carbsGoal
            case .fat:       return fatGoal
        }
    }
    
}

#Preview {
    let config  = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    StatsView(modelContext: container.mainContext)
}
