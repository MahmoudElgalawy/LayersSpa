//
//  CalenderModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 09/02/2025.
//

import Foundation

// MARK: - ReservationResponse
struct CalenderResponse: Codable {
    let status: Bool
    let message: String
    let data: CalenderData
}

// MARK: - ReservationData
struct CalenderData: Codable {
    let currentPage: Int
    let reservations: [Calender]
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case reservations = "data"
    }
}

// MARK: - Reservation
struct Calender: Codable,Equatable {
    
    let id: Int
    let businessID, branchID: String
    let calendarID, customerID, venueID, customerCategoryID: String?
    let reference, eventType, type, title: String?
    let titleIndex, color, backgroundColor, startTime: String?
    let endTime, start, end, reservationCode: String?
    let reservationStatus: Int
    let ecommOrderID: String?
    let parentDeliveryNoteID, parentSalesOrderID: String?
    let createdAt, updatedAt, deletedAt: String?
    let items: [CalenderItem]
    
    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case branchID = "branch_id"
        case calendarID = "calendar_id"
        case customerID = "customer_id"
        case venueID = "venue_id"
        case customerCategoryID = "customer_category_id"
        case reference
        case eventType = "event_type"
        case type, title
        case titleIndex = "title_index"
        case color
        case backgroundColor = "background_color"
        case startTime = "start_time"
        case endTime = "end_time"
        case start, end
        case reservationCode = "reservation_code"
        case reservationStatus = "reservation_status"
        case ecommOrderID = "ecomm_order_id"
        case parentDeliveryNoteID = "parent_delivery_note_id"
        case parentSalesOrderID = "parent_sales_order_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case items
    }
}

// MARK: - ReservationItem
struct CalenderItem: Codable,Equatable {
    let id, eventID, employeeID, serviceID: Int
    let categoryID, servicePrice, serviceQty: String?
    let startTime, endTime, start, end: String?
    let reference, childDeliveryNoteID, childSalesOrderID, calendarID: String?
    let createdAt, updatedAt, deletedAt: String?
    let reservationStatus: Int
    
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
        case start, end, reference
        case childDeliveryNoteID = "child_delivery_note_id"
        case childSalesOrderID = "child_sales_order_id"
        case calendarID = "calendar_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case reservationStatus = "reservation_status"
    }
}





// MARK: - Main Response Model
struct OrdersResponse: Codable {
    let status: Bool
    let message: String
    let data: [Order]
}

// MARK: - Order Model
struct Order: Codable {
    let id: Int
    let reference: Int
    let total: Double
    let product: Int
    let service: Int
    let paymentStatus: Int
    let orderStatus: OrderStatus
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, reference, total, product, service
        case paymentStatus = "payment_status"
        case orderStatus = "order_status"
        case createdAt = "created_at"
    }
}

// MARK: - Order Status Model
struct OrderStatus: Codable {
    let id: Int
    let name: String?
    let color: String?
}
