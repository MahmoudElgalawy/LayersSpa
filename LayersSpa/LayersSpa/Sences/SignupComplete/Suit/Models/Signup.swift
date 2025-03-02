//
//  Signup.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation

// MARK: - Signup
public struct Signup: Codable {
    let status: Bool
    let message: String
    let data: SignupDataClass?
}

// MARK: - DataClass
struct SignupDataClass: Codable {
    let userID: Int?
    let userName/*, email*/: String?
//    let phone: Int?
    let uuid, token: String?
    let businessID: Int?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userName = "user_name"
        case /*email,*/ /*phone,*/ uuid, token
        case businessID = "business_id"
    }
}

