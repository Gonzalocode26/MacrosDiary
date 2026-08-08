//
//  MealCard.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 31/07/2026.
//

import SwiftUI

struct MealCard: View {
    let meal: Meal
    let onAddTapped: () -> Void
    let onDelete: (FoodItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(meal.type)
                    .font(.headline)
                
                Spacer()
            }
            .padding(.horizontal)
            
            if meal.foods.isEmpty {
                Text("No foods added yet")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .padding(.horizontal)
                    .padding(.bottom, 4)
            } else {
                VStack(spacing: 0) {
                    ForEach(meal.foods) { food in
                        HStack{
                            HStack{
                                if let photoString = food.photo, let url = URL(string: photoString) {
                                    AsyncImage(url: url) { phase in
                                        if let image = phase.image {
                                            image.resizable().aspectRatio(contentMode: .fill)
                                        } else {
                                            Color.gray.opacity(0.3)
                                        }
                                    }
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    Image(systemName: food.iconName)
                                        .foregroundStyle(.purple)
                                        .font(.system(size: 24))
                                        .frame(width: 40, height: 40)
                                        .background(Color.purple.opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                Text(food.name)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text("\(Int(food.calories)) kcal")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Button {
                                    withAnimation{
                                        onDelete(food)
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.red)
                                        .padding(8)
                                        .background(Color.red.opacity(0.1))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                            .transition(.opacity.combined(with: .slide))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 8)
                        }
                        Divider().padding(.leading)
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
            }
            
            Button(action: onAddTapped) {
                Label("Add Food", systemImage: "plus")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .padding(.vertical, 8)
                    .foregroundStyle(.white)
                    .background(Color.purple)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}
