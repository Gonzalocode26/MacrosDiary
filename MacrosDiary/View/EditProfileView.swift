//
//  EditProfileView.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 26/1/26.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading ,spacing: 20) {
                    VStack{

                        VStack(spacing: 15) {
                            HStack {
                                Text("Name")
                                    .bold()
                                
                                Spacer()
                                
                                TextField("Name", text: $viewModel.name)
                                    .keyboardType(.default)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 160)
                                    .padding()
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(.gray.opacity(0.3)), lineWidth: 1))
                            }
                            
                            Divider()
                            
                            inputRow(
                                title: "Age",
                                value: $viewModel.age,
                                format: .number,
                                unit: "",
                                keyboard: .numberPad
                            )
                            
                            Divider()

                            inputRow(
                                title: "Weight",
                                value: $viewModel.weight,
                                format: .number.precision(.fractionLength(0...2)),
                                unit: "kg",
                                keyboard: .decimalPad
                            )

                            Divider()
                            
                            inputRow(
                                title: "Height",
                                value: $viewModel.height,
                                format: .number.precision(.fractionLength(0...2)),
                                unit: "cm",
                                keyboard: .decimalPad
                            )
                        }
                        .padding()
                        
                        VStack(alignment: .leading, spacing: 24) {
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Gender")
                                    .bold()
                                HStack{
                                    ForEach(Gender.allCases) { gender in
                                        ChipButton(
                                            title: gender.rawValue,
                                            isSelected: viewModel.gender == gender,
                                            action: {withAnimation {viewModel.gender = gender} }
                                        )
                                    }
                                    Spacer()
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Activity Level")
                                    .bold()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack{
                                        ForEach(UserActivity.allCases) { activity in
                                            ChipButton(
                                                title: activity.title,
                                                isSelected: viewModel.activityLevel == activity,
                                                action: { withAnimation {viewModel.activityLevel = activity} }
                                            )
                                        }
                                    }
                                }
                                .contentMargins(.horizontal, 0, for: .scrollContent)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Goal")
                                    .bold()
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack{
                                        ForEach(GoalType.allCases) { goal in
                                            ChipButton(
                                                title: goal.rawValue,
                                                isSelected: viewModel.selectedGoal == goal,
                                                action: { withAnimation{viewModel.selectedGoal = goal} }
                                            )
                                        }
                                    }
                                }
                                .contentMargins(.horizontal, 0, for: .scrollContent)
                            }
                        }
                        Button {
                            viewModel.recalculateMacros()
                            viewModel.save()
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.purple)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
                .navigationTitle("Edit Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") { dismiss()}
                    }
                }
            }
        }
        .background(Color(.systemGray6)).ignoresSafeArea()
    }
    
        @ViewBuilder
    func inputRow<T, F: ParseableFormatStyle>(
            title: String,
            value: Binding<T>,
            format: F,
            unit: String,
            keyboard: UIKeyboardType
        ) -> some View where F.FormatInput == T, F.FormatOutput == String {
            HStack{
                Text(title)
                    .bold()
                
                Spacer()
                
                TextField("0", value: value, format: format)
                    .keyboardType(keyboard)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 60)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(RoundedRectangle(cornerRadius: 8) .stroke(Color(.gray.opacity(0.3)), lineWidth: 1))
                
                
                if !unit.isEmpty {
                    Text(unit)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    struct ChipButton: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isSelected ? Color.purple : .gray.opacity(0.1))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }
    
    #Preview {
        EditProfileView(viewModel: ProfileViewModel())
    }
