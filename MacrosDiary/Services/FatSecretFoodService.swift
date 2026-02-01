//
//  FatSecretFoodService.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 7/1/26.
//

import Foundation

class FatSecretFoodService {
    
    private let searchUrl = "https://platform.fatsecret.com/rest/foods/search/v4"
    
    private let foodGetUrl = "https://platform.fatsecret.com/rest/food/v4"
    
    func searchFood(query: String) async throws -> [FatSecretFood] {
        
        let token = try await FatSecretAuthManager.shared.getValidToken()
        
        guard var components = URLComponents(string: searchUrl) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "search_expression", value: query),
            URLQueryItem(name: "max_results", value: "20"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "include_food_image", value: "true")
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
        
        return searchResponse.foodsSearch.results?.food ?? []
    }
    func getFood(id:String) async throws -> FatSecretFood? {
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
        do {
            let result = try JSONDecoder().decode(SingleFoodResponse.self, from: data)
            return result.food
        } catch {
            print("Error decoding fail: \(error)")
            return nil
        }
    }
}
