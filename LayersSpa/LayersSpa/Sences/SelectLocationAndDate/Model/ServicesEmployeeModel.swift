//
//  ServicesEmployeeModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 30/01/2025.
//

import Foundation

// MARK: - Main Response
struct ServicesEmployeeModel: Codable {
    let status: Bool
    let message: String
    let response: ResponseData
}

// MARK: - Response Data
struct ResponseData: Codable {
    let currentPage: Int?
    let data: [User]
    let firstPageURL: String?
    let from: Int?
    let lastPage: Int?
    let lastPageURL: String?
    let nextPageURL: String?
    let path: String?
    let perPage: Int?
    let prevPageURL: String?
    let to: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to
        case total
    }
}

// MARK: - User Model
struct User: Codable {
    let userName: String?
    let userID: Int?
    let profile: String?
    let profileURL: String?

    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case userID = "user_id"
        case profile
        case profileURL = "profile_url"
    }
}


