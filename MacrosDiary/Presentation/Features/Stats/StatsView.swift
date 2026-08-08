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
    let appContainer: AppContainer
    
    @StateObject private var viewModel: StatsViewModel
    @State private var selectedStat: StatType = .calories
    
    var isCurrentWeek: Bool {
        return Calendar.current.isDate(
            viewModel.currentWeekStart,
            equalTo: Date(),
            toGranularity: .weekOfYear
        )
    }
    
    init(appContainer: AppContainer) {
        self.appContainer = appContainer
        let vm = StatsViewModel(localContext: appContainer.modelContext, profileRepository: appContainer.userProfileRepository)
        _viewModel = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationStack {
            List{
                Section {
                    VStack(spacing: 20){
                        statsPicker
                        
                        weekNavigator
                        
                        chart
                        
                        DayFilterView(viewModel: viewModel)
                            .padding(.bottom, 8)
                    }
                    .background(Color.white)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                
                StatsHistoryListView(
                    viewModel: viewModel,
                    selectedStat: selectedStat)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchWeeklyDays()
            }
        }
        .background(Color(.systemGray6)).ignoresSafeArea()
    }
    
    // MARK: - Subviews
    
    private var statsPicker: some View {
        Picker("Stat", selection: $selectedStat) {
            ForEach(StatType.allCases, id: \.self) { type in
                Text(type.rawValue.capitalized).tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var weekNavigator: some View {
        HStack{
            Image(systemName: "chevron.backward")
                .font(.system(size: 20))
                .onTapGesture {viewModel.changeWeek(by: -1)}
                .foregroundStyle(.purple)
            
            Spacer()
            
            Text(viewModel.weekRangeString)
                .frame(minWidth: 150)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Image(systemName: "chevron.forward")
                .font(.system(size: 20))
                .onTapGesture {viewModel.changeWeek(by: 1)}
                .foregroundStyle(isCurrentWeek ? .gray.opacity(0.7) : .purple)
                .disabled(isCurrentWeek)
        }
        .padding(.horizontal)
    }
    
    private var chart: some View {
        ChartView(
            weeklyData: viewModel.weeklyData,
            selectedStat: selectedStat,
            goal: currentGoal
        )
        .frame(height: 200)
        .padding(.horizontal)
    }
    
    // MARK: - Computed Properties
    
    private var currentGoal: Double {
        switch selectedStat {
        case .calories:  return viewModel.calorieTarget
        case .protein:   return viewModel.proteinTarget
        case .carbs:     return viewModel.carbsTarget
        case .fat:       return viewModel.fatTarget
        }
    }
}

#Preview {
    let config  = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    let mockAppContainer = AppContainer(modelContext: container.mainContext)
    
    return StatsView(appContainer: mockAppContainer)
}
