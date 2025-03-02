//
//  Model.swift
//  LayersSpa
//
//  Created by Mahmoud on 07/01/2025.
//

//
//import Foundation
//import Alamofire
//
//struct CategoryResponse: Codable {
//    let status: Bool
//    let message: String
//    let data: [Cat]
//}
//
//struct Cat: Codable {
//    let id: Int
//    let sku: String?
//    let uuid: String
//    let productURL: String?
//    let type: String
//    let image: String?
//    let promotionImg: String?
//    let brandID: Int?
//    let price: String
//    let cost: String
//    let customerPrice: String?
//    let stock: Int
//    let sold: Int
//    let productKind: String
//    let taxID: String?
//    let taxInclusive: Int
//    let taxRate: Int
//    let status: Int
//    let showInMobile: Int
//    let alias: String?
//    let createdAt: String
//    let updatedAt: String
//    let branchID: [String]
//    let averageRating: String?
//    let imageURL: String?
//    let descriptions: [Descriptio]
//    let categories: [Categor]
//    let brand: Bran?
//    let promotionPrice: [PromotionPric]
//    let unit: Uni?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case sku
//        case uuid
//        case productURL = "product_url"
//        case type
//        case image
//        case promotionImg = "promotion_img"
//        case brandID = "brand_id"
//        case price 
//        case cost
//        case customerPrice = "customer_price"
//        case stock
//        case sold
//        case productKind = "product_kind"
//        case taxID = "tax_id"
//        case taxInclusive = "tax_inclusive"
//        case taxRate = "tax_rate"
//        case status
//        case showInMobile = "show_in_mobile"
//        case alias
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case branchID = "branch_id"
//        case averageRating = "average_rating"
//        case imageURL = "image_url"
//        case descriptions
//        case categories
//        case brand
//        case promotionPrice = "promotion_price"
//        case unit
//    }
//}
//
//struct Descriptio: Codable {
//    let productID: Int
//    let lang: String
//    let name: String
//    let keyword: String
//    let description: String
//    let content: String
//    
//    enum CodingKeys: String, CodingKey {
//        case productID = "product_id"
//        case lang
//        case name
//        case keyword
//        case description
//        case content
//    }
//}
//
//struct Categor: Codable {
//    let id: Int
//    let businessID: Int
//    let image: String?
//    let alias: String
//    let parent: Int
//    let top: Int
//    let status: Int
//    let sort: Int
//    let descriptions: [CategoryDescriptio]
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case businessID = "business_id"
//        case image
//        case alias
//        case parent
//        case top
//        case status
//        case sort
//        case descriptions
//    }
//}
//
//struct CategoryDescriptio: Codable {
//    let categoryID: Int?
//    let lang: String?
//    let title: String?
//    let keyword: String
//    let description: String
//    
//    enum CodingKeys: String, CodingKey {
//        case categoryID = "category_id"
//        case lang
//        case title
//        case keyword
//        case description
//    }
//}
//
//struct Bran: Codable {
//    let id: Int
//    let alias: String
//    let url: String?
//    let status: Int
//    let sort: Int
//    let name: String
//}
//
//struct PromotionPric: Codable {
//    let id: Int
//    let title: String
//    let productID: Int
//    let value: String
//    let type: Int
//    let status: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case title
//        case productID = "product_id"
//        case value
//        case type
//        case status
//    }
//}
//
//struct Uni: Codable {
//    let id: Int
//    let mainUnitID: Int?
//    let childUnitID: Int?
//    let value: Int
//    let main: UnitDetail
//    let child: UnitDetail
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case mainUnitID = "main_unit__id"
//        case childUnitID = "child_unit_id"
//        case value
//        case main
//        case child
//    }
//}
//
//struct UnitDetail: Codable {
//    let id: Int
//    let name: String
//}
//
//



