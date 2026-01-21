//
//  StatsViewModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 23/12/25.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
class StatsViewModel: ObservableObject {

    @Published var weeklyData: [DailyChartData] = []
    @Published var historyDays: [DiaryDay] = []
    @Published var currentWeekStart: Date = Date()
    @Published var selectedDate: Date? = nil
    
    var filteredDays: [DiaryDay] {
        guard let targetDate = selectedDate else {
            return historyDays
        }
        return historyDays.filter { day in
            Calendar.current.isDate(day.date, inSameDayAs: targetDate)
        }
    }
    
    var weekRangeString: String {
        let start = currentWeekStart
        
        let end = Calendar.current.date(byAdding: .day, value: 6, to: start)
        
        let startText = start.formatted(.dateTime.day().month())
        let endText = end!.formatted(.dateTime.day().month())
        
        return "\(startText) - \(endText)"
    }
    
    var modelContext: ModelContext
    
    init(localContext: ModelContext) {
        self.modelContext = localContext
        self.currentWeekStart = getStartOfWeek(for: Date())
        fetchWeeklyDays()
    }
    
    private func getStartOfWeek(for date: Date) -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
    }
    
     func fetchWeeklyDays() {
        let startDate = currentWeekStart
         let endDate = Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
         
        let filter = #Predicate<DiaryDay> { day in
            day.date >= startDate && day.date <= endDate
        }
        let descriptor = FetchDescriptor<DiaryDay>(predicate: filter, sortBy: [SortDescriptor(\.date)])
        
        guard let safeResults = try? modelContext.fetch(descriptor) else {return}
        
         self.historyDays = safeResults //This is to have access
         
        self.weeklyData = safeResults.map{ day in
            let allFoodsPerDay = day.meals.flatMap { $0.foods }
        
//            Reduce works as a calculator starting in (0)
            let totalCalories = allFoodsPerDay.reduce(0) {$0 + $1.calories}
            let totalProtein = allFoodsPerDay.reduce(0) {$0 + $1.protein}
            let totalCarbs = allFoodsPerDay.reduce(0) {$0 + $1.carbs}
            let totalFat = allFoodsPerDay.reduce(0) {$0 + $1.fat}
            
            return DailyChartData(date: day.date, calories: totalCalories, protein: totalProtein, carbs: totalCarbs, fats: totalFat)
        }
        print("📊Stats charged: \(weeklyData.count) days found")
    }
    
    func deletefood(food: FoodItem, meal: Meal) {
        if let index = meal.foods.firstIndex(where: { $0.id == food.id }) {
            meal.foods.remove(at: index)
        }
        modelContext.delete(food)
        try? modelContext.save()
        fetchWeeklyDays()
    }
    
    func changeWeek(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: value, to: currentWeekStart)  {
            currentWeekStart = newDate
            selectedDate = nil
            fetchWeeklyDays()
        }
    }
    
}


