//
//  FoodDetailView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 22/10/25.
//

import SwiftUI
import Charts

struct FoodDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: FoodDetailsViewModel
    
    var onFoodSelected: ((FoodDetails) -> Void)?
    
    init(food:FatSecretFood, onFoodSelected: ((FoodDetails) -> Void)?) {
        _viewModel = StateObject(wrappedValue: FoodDetailsViewModel(food: food))
        self.onFoodSelected = onFoodSelected
    }
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView{
                VStack(spacing: 24) {
                    Spacer()
                    headerSection
                    Text(viewModel.food.foodName)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    donutChartSection
                    
                    Color.clear.frame(height: 160)
                }
            }
            .ignoresSafeArea(edges: .top)
            
            controlSection
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadHighQualityImage()
        }
    }
    
    var headerSection: some View {
        Group {
            if let url = viewModel.highQualityUrl {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .accessibilityHidden(true)
                    } else if let error = phase.error {
                        let _ = print("Error loading AsyncImage: \(error.localizedDescription)")
                        placeholderImage
                    } else {
                        ZStack{
                            Color(.systemGray6)
                            ProgressView()
                        }
                        .frame(height: 250)
                    }
                }
                .id(url)
            } else {
                placeholderImage
            }
        }
    }
    
    var placeholderImage: some View {
        ZStack{
            Color(.systemGray6)
            Image(systemName: "fork.knife")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
        }
        .frame(height: 250)
    }
    
    var donutChartSection: some View {
        HStack(spacing: 40) {
            ZStack {
                Chart(viewModel.macroDistribution) { data in
                    SectorMark(
                        angle: .value("Macro", data.value),
                        innerRadius: .ratio(0.6),
                        angularInset: 2
                    )
                    .cornerRadius(5)
                    .foregroundStyle(data.type.color)
                }
                .frame(width: 150, height: 150)
                
                VStack(spacing: 0){
                    Text("\(Int(viewModel.currentCalories))")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("kcal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                legendRow(color: .red, name: "Protein", value: viewModel.currentProtein)
                legendRow(color: .blue, name: "Carbs", value: viewModel.currentCarbohydrates)
                legendRow(color: .yellow, name: "Fats", value: viewModel.currentFats)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    var controlSection: some View {
        VStack(spacing: 16) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Serving Unit")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    Menu {
                        if let servings = viewModel.food.servings?.serving {
                            ForEach(servings) { serving in
                                Button {
                                    viewModel.selectedServing = serving
                                } label: {
                                    Text(viewModel.formatServingLabel(serving))
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(viewModel.selectedServing != nil ? viewModel.formatServingLabel(viewModel.selectedServing!) : "Standard")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Group {
                    if viewModel.isWeightBased {
                        HStack(spacing: 8) {
                            TextField("0", value: $viewModel.userEnteredAmount, format: .number)
                                .keyboardType(.decimalPad)
                                .font(.title3)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(height: 44)
                                .background(Color(.tertiarySystemFill))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                                    if let textField = obj.object as? UITextField {
                                        textField.selectAll(nil)
                                    }
                                }
                            Text(viewModel.displayUnit)
                                .foregroundStyle(.secondary)
                                .fontWeight(.medium)
                        }
                        .frame(width: 120)
                    } else {
                        HStack(spacing: 0) {
                            Button(action: {
                                if viewModel.userEnteredAmount > 0.5 { viewModel.userEnteredAmount -= 0.5 }
                            }) {
                                Image(systemName: "minus")
                                    .frame(width: 40, height: 44)
                                    .contentShape(Rectangle())
                            }
                            .foregroundStyle(.primary)
                            
                            Text("\(viewModel.userEnteredAmount, specifier: "%.1f")")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(width: 40)
                                .multilineTextAlignment(.center)
                            
                            Button(action: { viewModel.userEnteredAmount += 0.5 }) {
                                Image(systemName: "plus")
                                    .frame(width: 40, height: 44)
                                    .contentShape(Rectangle())
                            }
                            .foregroundStyle(.primary)
                        }
                        .background(Color(.tertiarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
                            Button(action: {
                                let details = viewModel.createFoodDetails()
                                onFoodSelected?(details)
                                dismiss()
                            }) {
                                Text("Add Food")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(Color.purple)
                                    .foregroundStyle(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .padding(24)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
    
    func legendRow(color: Color, name: String, value: Double) -> some View {
        HStack {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(name).font(.subheadline).foregroundStyle(.secondary)
            Spacer()
            Text("\(Int(value))g").font(.headline)
        }
        .frame(width: 120)
    }
}
    
    #Preview {
        let sampleFood = FatSecretFood(foodId: "123", foodName: "Banana", foodType: "Generic", foodUrl: nil, foodImages: nil, servings: ServingWrapper(serving: [FatSecretServing(servingId: "1", servingDescription: "1 medium (7\" to 7-7/8\" long)", metricServingAmount: "118.00", metricServingUnit: "g", calories: "105", carbohydrate: "27.00", protein: "1.30", fat: "0.40")]))
        FoodDetailsView(food: sampleFood, onFoodSelected: nil)
    }
