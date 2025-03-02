//
//  Login.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation

// MARK: - Login
public struct Login: Codable {
    let status: Bool
    let message: String
    let data: LoginDataClass?
}

// MARK: - DataClass
public struct LoginDataClass: Codable {
    let userID: Int
    let uuid: String
    let businessID: Int
    let district, address1, longitude, latitude: String?
    let token, userName, phone, email: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case uuid
        case businessID = "business_id"
        case token, address1, longitude, latitude, district
        case userName = "user_name"
        case phone, email, image
    }
}

