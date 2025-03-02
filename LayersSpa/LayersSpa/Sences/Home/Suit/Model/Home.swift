//
//  Home.swift
//  LayersSpa
//
//  Created by 2B on 16/08/2024.
//

import Foundation

// MARK: - Home
public struct Home: Codable {
    let status: Bool
    let message: String
    let data: HomeDataClass?
}

// MARK: - DataClass
struct HomeDataClass: Codable {
    let products, services: [Product]
    let categories: [DataCategory]
}

// MARK: - DataCategory
struct DataCategory: Codable {
    let id: Int?
    let image, imageURL: String?
    let descriptions: [CategoryDescription]?

    enum CodingKeys: String, CodingKey {
        case id, image
        case imageURL = "image_url"
        case descriptions
    }
}

// MARK: - CategoryDescription
struct CategoryDescription: Codable {
    let categoryID: Int?
    let lang, title, keyword, description: String?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case lang, title, keyword, description
    }
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let sku: String?
    let image: String?
    let customerPrice: String?
    let branchID: [String]?
    let imageURL: String?
    let promotionImgURL: String?
    let categories: [ProductCategory]?
    let descriptions: [ProductDescription]?
    let unit: Unit?
    let type:String?

    enum CodingKeys: String, CodingKey {
        case id, sku, image,type
        case customerPrice = "customer_price"
        case branchID = "branch_id"
        case imageURL = "image_url"
        case promotionImgURL = "promotion_img_url"
        case categories, descriptions, unit
    }
}

// MARK: - ProductCategory
struct ProductCategory: Codable {
    let id, businessID: Int?
    let image: String?
    let alias: String?
    let parent, top, status, sort: Int?
    let attrID: String?
    let imageURL: String?
    let pivot: Pivot?

    enum CodingKeys: String, CodingKey {
        case id
        case businessID = "business_id"
        case image, alias, parent, top, status, sort
        case attrID = "attr_id"
        case imageURL = "image_url"
        case pivot
    }
}

// MARK: - Pivot
struct Pivot: Codable {
    let productID, categoryID: Int?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case categoryID = "category_id"
    }
}

// MARK: - ProductDescription
struct ProductDescription: Codable {
    let productID: Int?
    let lang, name, keyword, description: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case lang, name, keyword, description, content
    }
}

// MARK: - Unit
struct Unit: Codable {
    let id, mainUnitID, childUnitID, value: Int?
    let productID: Int?
    let main, child: Child?

    enum CodingKeys: String, CodingKey {
        case id
        case mainUnitID = "main_unit_id"
        case childUnitID = "child_unit_id"
        case value
        case productID = "product_id"
        case main, child
    }
}

// MARK: - Child
struct Child: Codable {
    let id: Int?
    let name: String?
}
