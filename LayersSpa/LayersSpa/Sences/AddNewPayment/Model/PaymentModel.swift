//
//  PaymentRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 10/02/2025.
//

import Foundation

// Main Response Model
struct PaymentResponse: Codable {
    let status: Bool
    let message: String
    let data: TransactionData
}

// Data Model
struct TransactionData: Codable {
    let uuid: String
    let businessID: Int
    let reference: Int
    let createdDate: String
    let type: String
    let accountID: Int
    let clearedDate: String
    let payeePayerType: String
    let payeePayerID: String
    let total: String
    let advancedPayment: Int
    let paidReceivedType: Int
    let moyaserRef: String?
    let moyaserPaymentID: String
    let ecommOrderID: String
    let updatedAt: String
    let createdAt: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case uuid
        case businessID = "business_id"
        case reference
        case createdDate = "created_date"
        case type
        case accountID = "account_id"
        case clearedDate = "cleared_date"
        case payeePayerType = "payee_payer_type"
        case payeePayerID = "payee_payer_id"
        case total
        case advancedPayment = "advanced_payment"
        case paidReceivedType = "paid_received_type"
        case moyaserRef = "moyaser_ref"
        case moyaserPaymentID = "moyaser_payment_id"
        case ecommOrderID = "ecomm_order_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
    }
}
