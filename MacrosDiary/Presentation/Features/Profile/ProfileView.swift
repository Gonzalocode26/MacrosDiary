//
//  ProfileView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 18/10/25.
//

import SwiftUI
import SwiftData


struct ProfileView: View {
    let appContainer: AppContainer
    
    @StateObject private var viewModel: ProfileViewModel
    @State var isShowingEditSheet: Bool = false
    
    init(appContainer: AppContainer) {
        self.appContainer = appContainer
        _viewModel = StateObject(wrappedValue: ProfileViewModel(repository: appContainer.userProfileRepository))
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Button {
                            isShowingEditSheet = true
                        } label: {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.purple)
                                
                                VStack(alignment: .leading) {
                                    Text(viewModel.name)
                                        .foregroundStyle(.primary)
                                        .font(.subheadline)
                                    
                                    Text("Edit your physical data")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.purple)
                            }
                            .padding(.vertical, 5)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(alignment: .leading) {
                        Text("Energy Target")
                            .foregroundStyle(.primary)
                            .font(.title3)
                            .fontWeight(.semibold)
                        HStack{
                            Image(systemName: "flame.fill")
                                .foregroundStyle(.orange)
                            Text("Daily Calories")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            Spacer()
                            TextField("0", value: $viewModel.calorieTarget, format: .number.precision(.fractionLength(0)))
                                .foregroundStyle(.primary)
                                .font(.subheadline)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                            Text("Kcal")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    VStack(alignment: .leading ,spacing: 16){
                        Text("Macro Targets")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        
                        macroRow(title: "Protein", color: .red, icon: "fish.fill", value: viewModel.proteinTarget)
                        Divider()
                        macroRow(title: "Carbs", color: .blue, icon: "carrot.fill", value: viewModel.carbsTarget)
                        Divider()
                        macroRow(title: "Fat", color: .yellow, icon: "drop.fill", value: viewModel.fatTarget)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
                .navigationTitle("Profile")
                .sheet(isPresented: $isShowingEditSheet) {
                    EditProfileView(viewModel: viewModel)
                }
            }
        }
        .background(Color(.systemGray6)).ignoresSafeArea()
    }
    
    @ViewBuilder
    private func macroRow(title: String, color: Color, icon: String, value: Double) -> some View {
        HStack{
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 14))
                    .frame(width: 20)
                Text(title)
                    .foregroundStyle(.secondary)
                    .font(.headline)
            }
            Spacer()
            Text("\(value, specifier: "%.0f")")
                .font(.subheadline)
                .foregroundStyle(.primary)
            Text("g")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryDay.self, Meal.self, FoodItem.self, configurations: config)
    let mockAppContainer = AppContainer(modelContext: container.mainContext)
    
    ProfileView(appContainer: mockAppContainer)
}
