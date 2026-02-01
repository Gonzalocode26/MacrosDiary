//
//  FatSecretAuthManager.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 7/1/26.
//

import Foundation


actor FatSecretAuthManager {
    
    static let shared = FatSecretAuthManager()
    
    private let clientId = Bundle.main.object(forInfoDictionaryKey: "FatSecretClientId") as? String ?? ""
    private let clientSecret = Bundle.main.object(forInfoDictionaryKey: "FatSecretClientSecret") as? String ?? ""
    
    private var currentToken: String?
    private var tokenExpirationDate: Date?
    
    private let tokenUrl = URL(string: "https://oauth.fatsecret.com/connect/token")!
    private init() {} //To avoid double instances
    
    func getValidToken() async throws -> String {
        if let token = currentToken,
           let expiration = tokenExpirationDate,
           Date() < expiration {
            return token
        }
        return try await fetchNewToken()
    }
    private func fetchNewToken() async throws -> String {
        
        var request = URLRequest(url: tokenUrl)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyComponents = [
            "grant_type": "client_credentials",
            "client_id": clientId,
            "client_secret": clientSecret,
        ]
        
        let bodyString = bodyComponents
            .map { "\($0.key)=\($0.value)"}
            .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let errorString = String(data: data, encoding: .utf8){
                print("Error Auth: \(errorString)")
            }
            throw URLError(.badServerResponse)
        }
        let tokenResponse = try JSONDecoder().decode(FatSecretToken.self, from: data)
        self.currentToken = tokenResponse.accessToken
        self.tokenExpirationDate = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn - 60))
        return tokenResponse.accessToken
    }
}
