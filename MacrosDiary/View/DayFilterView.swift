//
//  DayFilterView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 29/1/26.
//
import SwiftUI
import SwiftData

struct DayFilterView: View {
    @ObservedObject var viewModel: StatsViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("History")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    dayButton(
                        title: "All",
                        isSelected: viewModel.selectedDate == nil,
                        action: {
                            withAnimation { viewModel.selectedDate = nil }
                        }
                    )
                    
                    ForEach(0..<7, id: \.self) { index in
                        let date = Calendar.current.date(
                            byAdding: .day,
                            value: index,
                            to: viewModel.currentWeekStart
                        )!
                        let isSelected = Calendar.current.isDate(
                            date,
                            inSameDayAs: viewModel.selectedDate ?? Date.distantPast
                        )
                        
                        dayButton(
                            title: date.formatted(.dateTime.weekday(.wide)),
                            isSelected: isSelected,
                            action: {
                                withAnimation { viewModel.selectedDate = date }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func dayButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14))
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(isSelected ? Color.purple : Color.gray.opacity(0.1))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, configurations: config)
    let vm = StatsViewModel(localContext: container.mainContext)
    
    return DayFilterView(viewModel: vm)
        .padding()
}
