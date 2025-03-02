//
//  Services.swift
//  LayersSpa
//
//  Created by Marwa on 27/08/2024.
//

import Foundation

// MARK: - Services
public struct Services: Codable {
    let status: Bool
    let message: String
    let data: [ServicesData]?
}

// MARK: - Datum
public struct ServicesData: Codable {
    let id: Int?
    let uuid: String?
    let type: String?
    let image: String?
    let promotionImg: String?
    let price, cost, customerPrice: String?
    let stock, sold, minimum: Int?
    let kind: Int?
    let virtual: Int?
    let productKind: String?
    let status: Int?
    let branchID: [String]?
    let imageURL, promotionImgURL: String?
    let descriptions: [DatumDescription]?
    let categories: [Category]?
    let presents: [Present]?
    let unit: Unit?
    let promotionPrice: [PromotionPrice]?

    enum CodingKeys: String, CodingKey {
        case id, uuid
        case type
        case image
        case promotionImg = "promotion_img"
        case price, cost
        case customerPrice = "customer_price"
        case stock, sold, minimum
        case kind, virtual
        case productKind = "product_kind"
        case status
        case branchID = "branch_id"
        case imageURL = "image_url"
        case promotionImgURL = "promotion_img_url"
        case descriptions, categories, presents
        case unit
        case promotionPrice = "promotion_price"
    }
}

// MARK: - Brand
struct Brand: Codable {
    let id, businessID: Int?
    let parentID: Int?
    let nameEn, nameAr, alias: String?
    let image: String?
    let url: String?
    let status, sort: Int?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case parentID = "parent_id"
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case alias, image, url, status, sort
        case imageURL = "image_url"
    }
}

// MARK: - Category
struct Category: Codable {
    let id, businessID: Int?
    let image: String?
    let alias: String?
    let parent: Int?
    let top, status, sort: Int?
    let attrID: String?
    let imageURL: String?
    let pivot: Pivot?
    let descriptions: [CategoryDescription]?

    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case image, alias, parent, top, status, sort
        case attrID = "attr_id"
        case imageURL = "image_url"
        case pivot, descriptions
    }
}

// MARK: - DatumDescription
struct DatumDescription: Codable {
    let productID: Int?
    let lang, name, keyword, description: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case lang, name, keyword, description, content
    }
}

// MARK: - Present
struct Present: Codable {
    let id: Int
    let businessID: Int?
    let productID, qty, gift: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case productID = "product_id"
        case qty, gift
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - PromotionPrice
struct PromotionPrice: Codable {
    let productID: Int?
    let pricePromotion, dateStart, dateEnd: String?
    let statusPromotion: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case pricePromotion = "price_promotion"
        case dateStart = "date_start"
        case dateEnd = "date_end"
        case statusPromotion = "status_promotion"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



//struct Unit: Codable {
//    let id: Int
//    let mainUnitID: Int
//    let childUnitID: Int
//    let value: Int
//    let productID: Int
//}
