//
//  ChartView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 20/1/26.
//

import SwiftUI
import Charts

struct ChartView: View {
    let weeklyData: [DailyChartData]
    let selectedStat: StatType
    let goal: Double
    
    var chartYDomain: ClosedRange<Double> {
        let maxBar = weeklyData.map{getValue(for: $0)}.max() ?? 0
        let maxValue = max(maxBar, goal)
        return 0...(maxValue > 0 ? maxValue * 1.15 : goal * 1.15)
    }
    
    var body: some View {
        VStack{
            if !weeklyData.isEmpty {
                Chart {
                    RuleMark(y: .value("Goal", goal))
                        .foregroundStyle(selectedStat.color.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .annotation(position: .top, alignment: .leading) {
                            Text("Goal: \(Int(goal))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 4)
                        }
                    
                    ForEach(weeklyData) { item in
                        BarMark(
                            x: .value("Day", item.date, unit: .day),
                            y: .value("Value", getValue(for:item))
                        )
                        .foregroundStyle(selectedStat.color.gradient)
                    }
                }
                .chartYScale(domain: chartYDomain)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing)
                }
            } else {
                ContentUnavailableView("No Data", image: "chart.bart.xaxis", description: Text("Add meals to see your stats."))
            }
        }
        .frame(height: 200)
        .padding(.horizontal)
    }
    
    
    func getValue(for item: DailyChartData) -> Double {
        switch selectedStat {
            case .calories: return item.calories
            case .protein: return item.protein
            case .carbs: return item.carbs
            case .fat: return item.fats
        }
    }
}



#Preview {
    ChartView(weeklyData: [], selectedStat: .calories, goal: 2000)
}
