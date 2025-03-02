//
//  CheckPhoneExist.swift
//  LayersSpa
//
//  Created by Marwa on 26/08/2024.
//

import Foundation

// MARK: - CheckPhoneExist
public struct CheckPhoneExist: Codable {
    let status: Bool
    let message: String
}

struct OTPResponse: Codable {
    let status: Bool
    let message: String
    let data: Int
}


struct OTPVerificationResponse: Codable {
    let status: Bool
    let message: String
    let data: [String] // أو يمكن استخدام [Any] إذا كانت البيانات غير محددة
}
