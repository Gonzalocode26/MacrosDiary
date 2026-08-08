//
//  DeepLTranslationService.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 06/08/2026.
//

import Foundation

class DeepLTranslationService: TranslationServiceProtocol {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "DeepLApiKey") as? String ?? ""
    private var tokenUrl = URL(string: "https://api-free.deepl.com/v2/translate")!
    
    func translate(text: String, targetLanguage: String) async throws -> String {
        var request = URLRequest(url: tokenUrl)
        
        request.httpMethod = "POST"
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = DeepLRequest(text: [text], targetLang: targetLanguage)
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(DeepLResponse.self, from: data)
        
        return response.translations.first?.text ?? text
    }
}

// MARK: - Request Body

private struct DeepLRequest: Encodable {
    let text: [String]
    let targetLang: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case targetLang = "target_lang"
    }
}

// MARK: - Response

private struct DeepLResponse: Decodable {
    struct Translation: Decodable {
        let text: String
    }
    
    let translations: [Translation]
}
