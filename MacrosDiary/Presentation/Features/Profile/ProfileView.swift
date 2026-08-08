//
//  ProfileView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 18/10/25.
//

import SwiftUI


struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State var isShowingEditSheet: Bool = false
   
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
                            TextField("0", value: $viewModel.calorieGoal, format: .number.precision(.fractionLength(0)))
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
                        
                        macroRow(title: "Protein", color: .red, icon: "fish.fill", value: viewModel.proteinGoal)
                        Divider()
                        macroRow(title: "Carbs", color: .blue, icon: "carrot.fill", value: viewModel.carbsGoal)
                        Divider()
                        macroRow(title: "Fat", color: .yellow, icon: "drop.fill", value: viewModel.fatGoal)
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
    ProfileView(viewModel: ProfileViewModel())
}
