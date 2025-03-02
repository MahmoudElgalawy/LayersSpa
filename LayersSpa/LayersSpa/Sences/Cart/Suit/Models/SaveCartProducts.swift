//
//  Untitled.swift
//  LayersSpa
//
//  Created by 2B on 15/09/2024.
//

import Foundation

// MARK: - SaveCartProducts
public struct SaveCartProducts: Codable {
    let status: Bool
    let message: String
    let data: SaveCartProductsData
}

// MARK: - DataClass
public struct SaveCartProductsData: Codable {
    let id: Int?
    let uuid, paymentType: String?
    let userID: Int?
    let paymentID, representativeID: Int?
    let businessID: Int?
    let mosqueID, invoiceNumber, driverID: Int?
    let orderRate, shipping, discount: Int?
    let subtotal: Double?
    let paymentStatus, shippingStatus, status: Int?
    let tax:Double?
    let total: Double?
    let currency: String?
    let exchangeRate: Float?
    let received, balance: Int?
    let firstName, lastName: String?
    let address1, address2, longitude, latitude: String?
    let country, city: Int?
    let district, company, postcode: String?
    let phone: String?
    let email, comment, paymentMethod, shippingMethod: String?
    let userAgent, ip, transaction, deliveryDate: String?
    let posSessionID: Int?
    let createdAt, updatedAt: String?
    let reference: Int?
    let details: [OrderDetail]

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case userID = "user_id"
        case paymentID = "payment_id"
        case paymentType = "payment_type"
        case representativeID = "representative_id"
        case businessID = "business_id"
        case mosqueID = "mosque_id"
        case invoiceNumber = "invoice_number"
        case driverID = "driver_id"
        case orderRate = "order_rate"
        case subtotal, shipping, discount
        case paymentStatus = "payment_status"
        case shippingStatus = "shipping_status"
        case status, tax, total, currency
        case exchangeRate = "exchange_rate"
        case received, balance
        case firstName = "first_name"
        case lastName = "last_name"
        case address1, address2, longitude, latitude, country, city, district, company, postcode, phone, email, comment
        case paymentMethod = "payment_method"
        case shippingMethod = "shipping_method"
        case userAgent = "user_agent"
        case ip, transaction
        case deliveryDate = "delivery_date"
        case posSessionID = "pos_session_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reference
        case details
    }
}

struct OrderDetail: Codable {
    let id: Int
    let orderID: Int
    let productID: Int
    let employeeID: Int?
    

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case productID = "product_id"
        case employeeID = "employee_id"
    }
}
