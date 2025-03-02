//
//  Categories.swift
//  LayersSpa
//
//  Created by Marwa on 19/08/2024.
//

import Foundation

// MARK: - Categories
public struct Categories: Codable {
    let status: Bool
    let message: String
    let data: [CategoriesData]?
}

// MARK: - Datum
public struct CategoriesData: Codable {
    let id, businessID: Int?
    let image: String?
    let alias: String?
    let parent: String?                //*****
    let top, status, sort: Int?
    let attrID: String?
    let imageURL: String?
    let descriptions: [Description]?
    let products: [CategoriesProduct]?
 //   let brands: [JSONAny]
    let children: [CategoriesChild]?
  //  let parentObject: JSONNull?
    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case image, alias, parent, top, status, sort
        case attrID = "attr_id"
        case imageURL = "image_url"
        case descriptions, products, children // , brands
      //  case parentObject = "parent_object"
    }
}

// MARK: - Child
public struct CategoriesChild: Codable {
    let id, businessID: Int?
    let image: String?
    let alias: String?
    let parent: Int? //*****
    let top, status, sort: Int?
    let attrID: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case image, alias, parent, top, status, sort
        case attrID = "attr_id"
        case imageURL = "image_url"
    }
}

// MARK: - Description
public struct Description: Codable {
    let categoryID: Int?
    let lang, title, keyword, description: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case lang, title, keyword, description
    }
}

// MARK: - Product
public struct CategoriesProduct: Codable {
    let id: Int
    let sku: String?
    let uuid: String
    let productURL: String?
    let type: String
    let image: String?
    let promotionImg: String?
    let brandID: Int?
    let price: String
    let cost: String
    let customerPrice: String?
    let stock: Int
    let sold: Int
    let productKind: String
    let taxID: String?
    let taxInclusive: Int
    let taxRate: Int
    let status: Int
    let showInMobile: Int
    let alias: String?
    let createdAt: String
    let updatedAt: String
    let branchID: [String]?
    let averageRating: String?
    let imageURL: String?
    let descriptions: [Description]
    let categories: [Category]
    let brand: Brand?
    let promotionPrice: [PromotionPrice]
    let unit: Unit?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sku
        case uuid
        case productURL = "product_url"
        case type
        case image
        case promotionImg = "promotion_img"
        case brandID = "brand_id"
        case price
        case cost
        case customerPrice = "customer_price"
        case stock
        case sold
        case productKind = "product_kind"
        case taxID = "tax_id"
        case taxInclusive = "tax_inclusive"
        case taxRate = "tax_rate"
        case status
        case showInMobile = "show_in_mobile"
        case alias
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case branchID = "branch_id"
        case averageRating = "average_rating"
        case imageURL = "image_url"
        case descriptions
        case categories
        case brand
        case promotionPrice = "promotion_price"
        case unit
    }
    
    // MARK: - Pivot
    public struct CategoriesPivot: Codable {
        let categoryID, productID: Int?
        
        enum CodingKeys: String, CodingKey {
            case categoryID = "category_id"
            case productID = "product_id"
        }
    }
}


struct AnyDecodable: Decodable {
    let value: Any

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let arrayValue = try? container.decode([AnyDecodable].self) {
            value = arrayValue
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported data type")
        }
    }
}
