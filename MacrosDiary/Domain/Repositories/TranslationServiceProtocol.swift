//
//  TranslationServiceProtocol.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 06/08/2026.
//

protocol TranslationServiceProtocol {
    func translate(text: String, targetLanguage: String) async throws -> String
}
