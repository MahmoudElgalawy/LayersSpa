//
//  GetCartProducts.swift
//  LayersSpa
//
//  Created by Marwa on 17/09/2024.
//

import Foundation

// MARK: - GetCartProducts
public struct GetCartProducts: Codable {
    let status: Bool
    let message: String
    let data: GetCartDataClass
}

// MARK: - DataClass
public struct GetCartDataClass: Codable {
    let id: Int?
    let uuid: String?
    let userID: Int?
 //   let paymentID, paymentType, representativeID: JSONNull?
    let businessID: Int?
 //   let mosqueID, invoiceNumber, driverID: JSONNull?
    let orderRate, subtotal, shipping, discount: Int?
    let paymentStatus, shippingStatus, status, tax: Int?
    let total: Int?
    let currency: String?
   // let exchangeRate: JSONNull?
    let received, balance: Int?
    let firstName, lastName: String?
//    let address1, address2, longitude, latitude: JSONNull?
 //   let country, city: Int
  //  let district, company, postcode: JSONNull?
 //   let phone: String
 //   let email, comment, paymentMethod, shippingMethod: JSONNull?
 //   let userAgent, ip, transaction, deliveryDate: JSONNull?
    let posSessionID: Int?
    let createdAt, updatedAt: String?
    let reference: Int?
    let details: [Detail]?

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case userID = "user_id"
       // case paymentID = "payment_id"
     //   case paymentType = "payment_type"
     //   case representativeID = "representative_id"
        case businessID = "business_id"
      //  case mosqueID = "mosque_id"
     //   case invoiceNumber = "invoice_number"
     //   case driverID = "driver_id"
        case orderRate = "order_rate"
        case subtotal, shipping, discount
        case paymentStatus = "payment_status"
        case shippingStatus = "shipping_status"
        case status, tax, total, currency
       // case exchangeRate = "exchange_rate"
        case received, balance
        case firstName = "first_name"
        case lastName = "last_name"
      //  case address1, address2, longitude, latitude
    //    case country, city, district, company, postcode, phone, email, comment
      //  case paymentMethod = "payment_method"
      //  case shippingMethod = "shipping_method"
      //  case userAgent = "user_agent"
      //  case ip, transaction
      //  case deliveryDate = "delivery_date"
        case posSessionID = "pos_session_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case reference, details
    }
}

// MARK: - Detail
struct Detail: Codable {
    let id, orderID, productID, employeeID: Int?
   // let eventReference: JSONNull?
    let name: String?
    let price: Double?
    let qty, freeQty: Int?
    let totalPrice: Double?
  //  let tax: JSONNull?
    let sku, currency: String?
  //  let exchangeRate, attribute: JSONNull?
    let createdAt: String?
  //  let updatedAt: JSONNull?
    let product: Product

    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case productID = "product_id"
        case employeeID = "employee_id"
       // case eventReference = "event_reference"
        case name, price, qty
        case freeQty = "free_qty"
        case totalPrice = "total_price"
      //  case tax
        case sku, currency
      //  case exchangeRate = "exchange_rate"
      //  case attribute
        case createdAt = "created_at"
       // case updatedAt = "updated_at"
        case product
    }
}

//// MARK: - Product
//struct Product: Codable {
//    let id: Int
//    let sku: String?
//    let uuid: String
//    let productURL: String?
//    let type: String
//  //  let couponQty, upc, ean, jan: JSONNull?
// //   let isbn, mpn: JSONNull?
//    let image: String?
//  //  let barcode, barcodeText: JSONNull?
//    let promotionImg: String?
//    let brandID: Int
//    let supplierID: String?
// //   let venueID, venueAttributeID: JSONNull?
//    let price, cost: String
//    let customerPrice: String?
//    let stock, sold, minimum: Int
//    let weightClass: String?
//    let weight: Int
//    let lengthClass: String?
//    let length, width, height, kind: Int
//    let virtual: Int
//    let productKind, taxID: String
//    let taxInclusive: Int
//    let taxRate: Int?
//    let status: Int
//    let showInMobile, supplierChain: String
//    let sort, view: Int
//    let alias, dateLastview: String?
// //   let dateAvailable: JSONNull?
//    let businessID, accItemID: Int
//  //  let createdAt: JSONNull?
//    let updatedAt: String
////    let branchID: JSONNull?
//    let storeActive: Int
//  //  let storeActiveFromDate, storeActiveToDate: JSONNull?
//    let parentType: String
// //   let standardProductID: JSONNull?
//    let imageURL: String
//    let promotionImgURL: String
//    let descriptions: [ProductDescription]
//    let categories: [Category]
////    let brand: JSONNull?
//    let attributes, images, presents, promotionPrice: [JSONAny]
//    let groups: [Group]
//    let builds: [JSONAny]
//    let unit: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case id, sku, uuid
//        case productURL = "product_url"
//        case type
//        case couponQty = "coupon_qty"
//        case upc, ean, jan, isbn, mpn, image, barcode
//        case barcodeText = "barcode_text"
//        case promotionImg = "promotion_img"
//        case brandID = "brand_id"
//        case supplierID = "supplier_id"
//        case venueID = "venue_id"
//        case venueAttributeID = "venue_attribute_id"
//        case price, cost
//        case customerPrice = "customer_price"
//        case stock, sold, minimum
//        case weightClass = "weight_class"
//        case weight
//        case lengthClass = "length_class"
//        case length, width, height, kind, virtual
//        case productKind = "product_kind"
//        case taxID = "tax_id"
//        case taxInclusive = "tax_inclusive"
//        case taxRate = "tax_rate"
//        case status
//        case showInMobile = "show_in_mobile"
//        case supplierChain = "supplier_chain"
//        case sort, view, alias
//        case dateLastview = "date_lastview"
//        case dateAvailable = "date_available"
//        case businessID = "business_id"
//        case accItemID = "acc_item_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case branchID = "branch_id"
//        case storeActive = "store_active"
//        case storeActiveFromDate = "store_active_from_date"
//        case storeActiveToDate = "store_active_to_date"
//        case parentType = "parent_type"
//        case standardProductID = "standard_product_id"
//        case imageURL = "image_url"
//        case promotionImgURL = "promotion_img_url"
//        case descriptions, categories, brand, attributes, images, presents
//        case promotionPrice = "promotion_price"
//        case groups, builds, unit
//    }
//}
//
//// MARK: - Category
//struct Category: Codable {
//    let id, businessID: Int
//    let image: String
//    let alias: String
//    let parent, top, status, sort: Int
//    let attrID: String
//    let imageURL: String
//    let pivot: Pivot
//    let descriptions: [CategoryDescription]
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case businessID = "business_id"
//        case image, alias, parent, top, status, sort
//        case attrID = "attr_id"
//        case imageURL = "image_url"
//        case pivot, descriptions
//    }
//}
//
//// MARK: - CategoryDescription
//struct CategoryDescription: Codable {
//    let categoryID: Int
//    let lang, title, keyword, description: String
//
//    enum CodingKeys: String, CodingKey {
//        case categoryID = "category_id"
//        case lang, title, keyword, description
//    }
//}
//
//// MARK: - Pivot
//struct Pivot: Codable {
//    let productID, categoryID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case productID = "product_id"
//        case categoryID = "category_id"
//    }
//}
//
//// MARK: - ProductDescription
//struct ProductDescription: Codable {
//    let productID: Int
//    let lang: String
//    let name, keyword, description, content: String?
//
//    enum CodingKeys: String, CodingKey {
//        case productID = "product_id"
//        case lang, name, keyword, description, content
//    }
//}
//
//// MARK: - Group
//struct Group: Codable {
//    let groupID, productID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case groupID = "group_id"
//        case productID = "product_id"
//    }
//}
//
