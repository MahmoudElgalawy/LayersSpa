//
//  ServiceDetails.swift
//  LayersSpa
//
//  Created by Marwa on 28/08/2024.
//

import Foundation

// MARK: - ServiceDetails
public struct ServiceDetails: Codable {
    let status: Bool
    let message: String
    let data: ServiceDetailsDataClass?
}

// MARK: - DataClass
public struct ServiceDetailsDataClass: Codable {
    let id: Int?
    let sku, uuid: String?
    let productURL: String?
    let type: String?
    let couponQty: Int?
    let image, promotionImg: String?
    let brandID: Int?
    let supplierID, price, cost, customerPrice: String?
    let stock, sold, minimum, weight: Int?
    let length, width, height, kind: Int?
    let virtual: Int?
    let productKind, taxID: String?
    let taxInclusive: Int?
    let status: Int?
    let showInMobile:Int?
    let supplierChain: Int?
    let sort, view: Int?
    let alias: String?
    let businessID: Int?
    let createdAt, updatedAt: String?
    let branchID: [String]?
    let imageURL, promotionImgURL: String?
    let descriptions: [Description]?
    let categories: [Category]?
    let images: [Image]?
    let presents: [Present]?
    let promotionPrice: [PromotionPrice]?
    let units: [Unit]?
    let belongs: [Belong]?

    enum CodingKeys: String, CodingKey {
        case id, sku, uuid
        case productURL = "product_url"
        case type
        case couponQty = "coupon_qty"
        case image
        case promotionImg = "promotion_img"
        case brandID = "brand_id"
        case supplierID = "supplier_id"
        case price, cost
        case customerPrice = "customer_price"
        case stock, sold, minimum, weight, length, width, height, kind, virtual
        case productKind = "product_kind"
        case taxID = "tax_id"
        case taxInclusive = "tax_inclusive"
      //  case taxRate = "tax_rate"
        case status
        case showInMobile = "show_in_mobile"
        case supplierChain = "supplier_chain"
        case sort, view, alias
        case businessID = "business_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case branchID = "branch_id"
        case imageURL = "image_url"
        case promotionImgURL = "promotion_img_url"
        case descriptions, categories, images, presents
        case promotionPrice = "promotion_price"
        case units, belongs
    }
}

// MARK: - Belong
public struct Belong: Codable {
    let id, buildID, productID: Int?
    let type: String?
    let quantity: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case buildID = "build_id"
        case productID = "product_id"
        case type, quantity
    }
}


// MARK: - Image
public struct Image: Codable {
    let id: Int?
    let image: String?
    let productID: Int?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, image
        case productID = "product_id"
        case imageURL = "image_url"
    }
}
