//  
//  BookingSummeryViewModelType.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import Foundation

/// BookingSummery Input & Output
///
typealias BookingSummeryViewModelType = BookingSummeryViewModelInput & BookingSummeryViewModelOutput

/// BookingSummery ViewModel Input
///
protocol BookingSummeryViewModelInput {}

/// BookingSummery ViewModel Output
///
protocol BookingSummeryViewModelOutput {
    func getSectionItem (_ index: Int) -> BookingSummerySectionsItem
    func getSectionsNumber() -> Int
    func getSectionHeaderInfo(_ index: Int) -> BookingSummerySectionsVM 
    var cartItems: [ProductVM] { get set }
    var productsId: [String]{ get set }
    func loadCartData()
    func removeBookingDetailsSection()
}
