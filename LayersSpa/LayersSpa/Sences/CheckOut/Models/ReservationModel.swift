//
//  ReservationModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 05/02/2025.
//

import Foundation

// Main Response Model
struct ReservationResponse: Codable {
    let status: Bool
    let message: String
    let data: ReservationData
}

// Reservation Data
struct ReservationData: Codable {
    let businessID: Int?
    let customerID: Int?
    let eventType: String?
    let title: String?
    let color: String?
    let backgroundColor: String?
    let start: String?
    let end: String?
    let reservationCode: String?
    let reservationStatus: Int?
    let branchID: String?
    let ecommOrderID: Int?
    let updatedAt: String?
    let createdAt: String?
    let id: Int?
    let items: [ReservationItem]?
    
    enum CodingKeys: String, CodingKey {
        case businessID = "business_id"
        case customerID = "customer_id"
        case eventType = "event_type"
        case title
        case color
        case backgroundColor = "background_color"
        case start
        case end
        case reservationCode = "reservation_code"
        case reservationStatus = "reservation_status"
        case branchID = "branch_id"
        case ecommOrderID = "ecomm_order_id"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case id
        case items
    }
}

// Reservation Items (Services)
struct ReservationItem: Codable {
    let id: Int?
    let eventID: Int?
    let employeeID: Int?
    let serviceID: Int?
    let categoryID: Int?
    let servicePrice: Double?
    let serviceQty: String?
    let startTime: String?
    let endTime: String?
    let start: String?
    let end: String?
    let reference: String?
    let childDeliveryNoteID: Int?
    let childSalesOrderID: Int?
    let calendarID: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let reservationStatus: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventID = "event_id"
        case employeeID = "employee_id"
        case serviceID = "service_id"
        case categoryID = "category_id"
        case servicePrice = "service_price"
        case serviceQty = "service_qty"
        case startTime = "start_time"
        case endTime = "end_time"
        case start
        case end
        case reference
        case childDeliveryNoteID = "child_delivery_note_id"
        case childSalesOrderID = "child_sales_order_id"
        case calendarID = "calendar_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case reservationStatus = "reservation_status"
    }
}
