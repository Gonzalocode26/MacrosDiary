//
//  FatSecretModel.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 7/1/26.
//

import Foundation

struct FatSecretSearchResponse: Codable {
    let foodsSearch: FoodSearchContainer
    
    enum CodingKeys: String, CodingKey {
        case foodsSearch = "foods_search"
    }
}

struct FoodSearchContainer: Codable {
    let maxResults: String?
    let totalResults: String?
    let pageNumber: String?
    let results: FoodList?
    
    enum CodingKeys: String, CodingKey {
        case maxResults = "max_results"
        case totalResults = "total_results"
        case pageNumber = "page_number"
        case results
    }
}

struct FoodList: Codable {
    let food: [FatSecretFood]
}

struct FatSecretFood: Codable, Identifiable {
    
    var id: String {foodId}
    
    let foodId: String
    let foodName: String
    let foodType: String?
    let foodUrl: String?
    
    let foodImages: FoodImageWrapper?
    let servings: ServingWrapper?
    
    enum CodingKeys: String, CodingKey {
        case foodId = "food_id"
        case foodName = "food_name"
        case foodType = "food_type"
        case foodUrl = "food_url"
        case foodImages = "food_images"
        case servings
    }
    
    var mainImageUrl: URL? {
        guard let urlString = foodImages?.foodImage.first?.imageUrl else {return nil}
        return URL(string:urlString)
    }
}

struct FoodImageWrapper: Codable {
    let foodImage: [FatSecretImage]
    
    enum CodingKeys: String, CodingKey {
        case foodImage = "food_image"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let images = try? container.decode([FatSecretImage].self, forKey: .foodImage) {
            self.foodImage = images
        }
        
        else if let singleImage = try? container.decode(FatSecretImage.self, forKey: .foodImage) {
            self.foodImage = [singleImage]
        }
        else {
            self.foodImage = []
        }
    }
}

struct FatSecretImage: Codable {
    let imageUrl: String
    let imageType: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case imageType = "image_type"
    }
}

struct ServingWrapper: Codable {
    let serving: [FatSecretServing]
}

struct FatSecretServing: Codable, Identifiable, Hashable {
    var id: String {servingId}
    
    let servingId: String
    let servingDescription: String
    let metricServingAmount: String?
    let metricServingUnit: String?
    
    let calories: String?
    let carbohydrate: String?
    let protein: String?
    let fat: String?
    let cholesterol: String?
    let sodium: String?
    let sugar: String?
    let fiber: String?
    
    enum CodingKeys: String, CodingKey {
        case servingId = "serving_id"
        case servingDescription = "serving_description"
        case metricServingAmount = "metric_serving_amount"
        case metricServingUnit = "metric_serving_unit"
        case calories, carbohydrate, protein, fat
        case cholesterol, sodium, sugar, fiber
    }
    
    var caloriesValue: Double { Double(calories ?? "") ?? 0}
    var carbohydrateValue: Double { Double(carbohydrate ?? "") ?? 0}
    var proteinValue: Double { Double(protein ?? "") ?? 0}
    var fatValue: Double { Double(fat ?? "") ?? 0}
    var cholesterolValue: Double { Double(cholesterol ?? "") ?? 0}
    var sodiumValue: Double { Double(sodium ?? "") ?? 0}
    var sugarValue: Double { Double(sugar ?? "") ?? 0}
    var fiberValue: Double { Double(fiber ?? "") ?? 0}
}
