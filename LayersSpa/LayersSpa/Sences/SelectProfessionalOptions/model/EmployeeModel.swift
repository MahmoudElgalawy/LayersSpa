//
//  EmployeeModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 30/01/2025.
//

import Foundation

// البيانات الرئيسية
struct EmployeeResponse: Codable {
    let status: Bool
    let message: String
    let data: EmployeeData
}

// بيانات الموظفين
struct EmployeeData: Codable {
    let data: [Employee]
}

// هيكل الموظف
struct Employee: Codable {
    let empData: EmpData
    let workingHours: WorkingHours
    let otherEvents: [OtherEvent]

    enum CodingKeys: String, CodingKey {
        case empData = "emp_data"
        case workingHours = "working_hours"
        case otherEvents = "other_events"
    }
}

// بيانات الموظف
struct EmpData: Codable {
    let id: Int?
    let name: String?
    let userName: String?
    let userPassword: String?
    let phone: String?
    let inventoryAuditProcessCode: String?
    let uuid: String?
    let branchId: String?
    let businessId: String?
    let profileInfo: ProfileInfo

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case userName = "user_name"
        case userPassword = "user_password"
        case phone
        case inventoryAuditProcessCode = "inventory_audit_process_code"
        case uuid
        case branchId = "branch_id"
        case businessId = "business_id"
        case profileInfo = "profile_info"
    }
}

//// الدور
//struct Role: Codable {
//    let id: Int
//    let uuid: String
//    let name: String
//    let nameAr: String
//    let type: String
//    let viewType: String
//    let userType: String?
//    let businessId: String
//    let image: String?
//    let createCashAccount: Int
//    let createdAt: String
//    let updatedAt: String
//    let deletedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, uuid, name
//        case nameAr = "name_ar"
//        case type
//        case viewType = "view_type"
//        case userType = "user_type"
//        case businessId = "business_id"
//        case image
//        case createCashAccount = "create_cash_account"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//    }
//}



// تفاصيل الصورة الشخصية
struct ProfileInfo: Codable {
    let color: String?
    let profileImage: String
    let name: String?

    enum CodingKeys: String, CodingKey {
        case color
        case profileImage = "profile_image"
        case name
    }
}

// ساعات العمل
struct WorkingHours: Codable {
    let from: String?
    let to: String?
}

// الأحداث الأخرى
struct OtherEvent: Codable {
    let id: Int?
    let eventId: Int?
    let employeeId: Int?
    let serviceId: Int?
    let categoryId: Int?
    let servicePrice: Double?
    let serviceQty: String?
    let startTime: String?
    let endTime: String?
    let start: String?
    let end: String?
    let reference: String?
    let childDeliveryNoteId: String?
    let childSalesOrderId: Int?
    let calendarId: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?
    let reservationStatus: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case employeeId = "employee_id"
        case serviceId = "service_id"
        case categoryId = "category_id"
        case servicePrice = "service_price"
        case serviceQty = "service_qty"
        case startTime = "start_time"
        case endTime = "end_time"
        case start, end, reference
        case childDeliveryNoteId = "child_delivery_note_id"
        case childSalesOrderId = "child_sales_order_id"
        case calendarId = "calendar_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case reservationStatus = "reservation_status"
    }
}


//struct EmployeeResponse: Codable {
//    let status: Bool
//    let message: String
//    let data: EmployeeData
//}
//
//// Data container model
//struct EmployeeData: Codable {
//    let data: [Employee]
//}
//
//// Employee model
//struct Employee: Codable {
//    let empData: EmpData
//    let workingHours: WorkingHours
//    let otherEvents: [Event]
//    
//    enum CodingKeys: String, CodingKey {
//        case empData = "emp_data"
//        case workingHours = "working_hours"
//        case otherEvents = "other_events"
//    }
//}
//
//// Employee data model
//struct EmpData: Codable {
//    let id: Int
//    let name: String
//    let userName: String
//    let userPassword: String?
//    let phone: String
//    let inventoryAuditProcessCode: String?
//    let uuid: String
//    let branchId: String
//    let businessId: String
//    let roles: [Role]
//    let branch: Branch
//    let profileInfo: ProfileInfo
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case userName = "user_name"
//        case userPassword = "user_password"
//        case phone
//        case inventoryAuditProcessCode = "inventory_audit_process_code"
//        case uuid
//        case branchId = "branch_id"
//        case businessId = "business_id"
//        case roles
//        case branch
//        case profileInfo = "profile_info"
//    }
//}
//
//// Role model
//struct Role: Codable {
//    let id: Int
//    let uuid: String
//    let name: String
//    let nameAr: String
//    let type: String
//    let viewType: String
//    let userType: String?
//    let businessId: String
//    let image: String?
//    let createCashAccount: Int
//    let createdAt: String
//    let updatedAt: String
//    let deletedAt: String?
//    let pivot: Pivot
//}
//
//// Pivot model for role-user relation
//struct Pivot: Codable {
//    let userId: Int
//    let roleId: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case userId = "user_id"
//        case roleId = "role_id"
//    }
//}
//
//// Branch model
//struct Branch: Codable {
//    let id: Int
//    let uuid: String
//    let businessId: Int
//    let companyId: String?
//    let name: String
//    let nameAr: String
//    let vatNumber: String
//    let vatNumberCheck: String
//    let phone: String
//    let email: String
//    let address: String
//    let longitude: String
//    let latitude: String?
//    let countryId: Int
//    let city: String
//    let state: String?
//    let district: String?
//    let status: Int
//    let createdAt: String
//    let updatedAt: String
//}
//
//// Profile info model
//struct ProfileInfo: Codable {
//    let color: String?
//    let profileImage: String
//    let name: String
//    
//    enum CodingKeys: String, CodingKey {
//        case color
//        case profileImage = "profile_image"
//        case name
//    }
//}
//
//// Working hours model
//struct WorkingHours: Codable {
//    let from: String
//    let to: String
//}
//
//// Event model
//struct Event: Codable {
//    let id: Int
//    let eventId: Int
//    let employeeId: Int
//    let serviceId: Int
//    let categoryId: Int?
//    let servicePrice: String?
//    let serviceQty: String
//    let startTime: String
//    let endTime: String
//    let start: String
//    let end: String
//    let reference: String
//    let childDeliveryNoteId: String?
//    let childSalesOrderId: String?
//    let calendarId: String
//    let createdAt: String
//    let updatedAt: String
//    let deletedAt: String?
//    let reservationStatus: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case eventId = "event_id"
//        case employeeId = "employee_id"
//        case serviceId = "service_id"
//        case categoryId = "category_id"
//        case servicePrice = "service_price"
//        case serviceQty = "service_qty"
//        case startTime = "start_time"
//        case endTime = "end_time"
//        case start
//        case end
//        case reference
//        case childDeliveryNoteId = "child_delivery_note_id"
//        case childSalesOrderId = "child_sales_order_id"
//        case calendarId = "calendar_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//        case reservationStatus = "reservation_status"
//    }
//}
