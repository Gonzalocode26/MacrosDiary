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
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var isCurrentWeek: Bool {
        return Calendar.current.isDate(
            viewModel.currentWeekStart,
            equalTo: Date(),
            toGranularity: .weekOfYear
        )
    }
    
    init(modelContext: ModelContext, profileViewModel: ProfileViewModel) {
        let vm = StatsViewModel(localContext: modelContext)
        _viewModel = StateObject(wrappedValue: vm)
        self.profileViewModel = profileViewModel
    }
    
    var body: some View {
        NavigationStack {
            List{
                // MARK: - Chart Section
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
                
                
                // MARK: - History Section
                
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
            case .calories:  return profileViewModel.calorieGoal
            case .protein:   return profileViewModel.proteinGoal
            case .carbs:     return profileViewModel.carbsGoal
            case .fat:       return profileViewModel.fatGoal
        }
    }
}

#Preview {
    let config  = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    StatsView(modelContext: container.mainContext, profileViewModel: ProfileViewModel())
}
