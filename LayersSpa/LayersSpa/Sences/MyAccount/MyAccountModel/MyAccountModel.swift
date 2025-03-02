//
//  MyAccountModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 02/02/2025.
//

import Foundation

import Foundation

struct APIResponse: Codable {
    let status: Bool
    let message: String
    let data: UserData
}

struct UserData: Codable {
    var id: Int
    var firstName: String
    var lastName: String?
    var email: String
    let token: String?
    let password: String
    var phone: String
    var image: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case token
        case password
        case phone
        case image
    }
    
}

