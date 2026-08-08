//
//  UserProfileRepositoryProtocol.swift
//  MacrosDiary
//
//  Created by Gonzalo Menéndez on 02/08/2026.
//

import Foundation

protocol UserProfileRepositoryProtocol {
    func loadProfile() -> ProfileData
    func saveProfile(_ data: ProfileData)
}
