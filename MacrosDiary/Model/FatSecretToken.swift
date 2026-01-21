//
//  FatSecretToken.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 7/1/26.
//
import Foundation

struct FatSecretToken: Decodable, Sendable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int
    
}

extension FatSecretToken{
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(String.self, forKey: .tokenType)
        self.expiresIn = try container.decode(Int.self, forKey: .expiresIn)
    }
    nonisolated func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(accessToken, forKey: .accessToken)
            try container.encode(tokenType, forKey: .tokenType)
            try container.encode(expiresIn, forKey: .expiresIn)
        }
}
