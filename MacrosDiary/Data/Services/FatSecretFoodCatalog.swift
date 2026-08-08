//
//  FatSecretFoodService.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 7/1/26.
//

import Foundation

class FatSecretFoodCatalog: FoodCatalogProtocol {
    
    private let searchUrl = "https://platform.fatsecret.com/rest/foods/search/v4"
    
    private let foodGetUrl = "https://platform.fatsecret.com/rest/food/v4"
    
    func foodSearchResult(query: String) async throws -> [FoodSearchResult] {
        
        let token = try await FatSecretAuthManager.shared.getValidToken()
        
        guard var components = URLComponents(string: searchUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "search_expression", value: query),
            URLQueryItem(name: "max_results", value: "20"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "include_food_images", value: "true")
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let string = String(data: data, encoding: .utf8) { print("Error search api:  \(string)")}
            throw URLError(.badServerResponse)
        }
        
        let searchResponse = try JSONDecoder().decode(FatSecretSearchResponse.self, from: data)
        let apiFoods = searchResponse.foodsSearch.results?.food ?? []
        
        let domainResults = apiFoods.map { dto in
            return FoodSearchResult(
                id: dto.id,
                name: dto.foodName,
                type: dto.foodType,
                imageUrl: dto.mainImageUrl?.absoluteString
            )
        }
        
        return domainResults
    }
    
    func getFood(id:String) async throws -> FoodDetails {
        let token = try await FatSecretAuthManager.shared.getValidToken()
        
        guard var components = URLComponents(string: foodGetUrl) else {throw URLError(.badURL)}
        components.queryItems = [
            URLQueryItem(name: "food_id", value: id),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "include_food_images", value: "true")
        ]
        
        guard let url = components.url else {throw URLError(.badURL)}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
#if DEBUG
        if let jsonString = String(data: data, encoding: .utf8) {
            print("----RAW JSON RESPONSE------")
            print(jsonString)
            print("---------------------------")
        }
#endif
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        struct SingleFoodResponse: Decodable {
            let food: FatSecretFood
        }
        
        let result = try JSONDecoder().decode(SingleFoodResponse.self, from: data)
        let apiFood = result.food
        
        let dtosServings = apiFood.servings?.serving ?? []
        
        let domainServings: [FoodServing] = dtosServings.map { dto in
            FoodServing(
                id: dto.id,
                description: dto.servingDescription,
                amount: Double(dto.metricServingAmount ?? "") ?? 1.0,
                unit: dto.metricServingUnit ?? "unit",
                calories: dto.caloriesValue,
                carbs: dto.carbohydrateValue,
                protein: dto.proteinValue,
                fat: dto.fatValue,
                cholesterol: dto.cholesterolValue,
                sodium: dto.sodiumValue,
                sugar: dto.sugarValue,
                fiber: dto.fiberValue
            )
        }
        
        return FoodDetails(
            id: apiFood.id,
            name: apiFood.foodName,
            photoURL: apiFood.mainImageUrl,
            servings: domainServings
        )
    }
}
