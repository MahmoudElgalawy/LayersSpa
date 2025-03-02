//
//  ResetPassword.swift
//  LayersSpa
//
//  Created by Marwa on 26/08/2024.
//

import Foundation

// MARK: - ResetPassword
public struct ResetPassword: Codable {
    let status: Bool
    let message: String
    let data: [String]
}

struct code: Codable{
    let code: Int
}
