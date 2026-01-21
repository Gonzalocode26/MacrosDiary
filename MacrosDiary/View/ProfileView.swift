//
//  ProfileView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 18/10/25.
//

import SwiftUI


struct ProfileView: View {
    //    @State var userGoal: UserProfile
    
    @AppStorage("calorie_goal") private var calorieGoal: Double = 2000
    @AppStorage("protein_goal") private var proteinGoal: Double = 150
    @AppStorage("carbs_goal") private var carbsGoal: Double = 250
    @AppStorage("fat_goal") private var fatGoal: Double = 60
    
    var body: some View {
        NavigationStack{
            Form {
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundStyle(.gray.opacity(0.3))
                        VStack(alignment: .leading) {
                            Text("User Profile")
                                .font(.subheadline)
                            Text("Update your daily goals")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                }
                Section("Energy Target") {
                    HStack{
                        Image(systemName: "flame.fill")
                            .foregroundStyle(.purple)
                        Text("Daily Calories")
                        Spacer()
                        TextField("Kcal", value: $calorieGoal, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        Text("Kcal")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                Section("Macro Targets"){
                    macroRow(title: "Protein", color: .red, icon: "fish.fill", value: $proteinGoal)
                    macroRow(title: "Carbs", color: .blue, icon: "carrot.fill", value: $carbsGoal)
                    macroRow(title: "Fat", color: .yellow, icon: "drop.fill", value: $fatGoal)
                }
            }
        }
        .navigationTitle("Profile")
    }
}

@ViewBuilder
private func macroRow(title: String, color: Color, icon: String, value: Binding<Double>) -> some View {
    HStack{
        Image(systemName: icon).foregroundStyle(color)
        Text(title)
        Spacer()
        TextField("g", value: value, format: .number)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.trailing)
            .frame(width: 80)
        Text("g")
            .foregroundStyle(.secondary)
            .font(.caption)
    }
}

#Preview {
    ProfileView()
}
