//
//  FoodCatalogProtocol.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 28/07/2026.
//

protocol FoodCatalogProtocol: Sendable {
    func foodSearchResult(query: String) async throws -> [FoodSearchResult]
    
    func getFood(id: String) async throws -> FoodDetails
}
