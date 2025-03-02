//  
//  CheckOutViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import Foundation

/// CheckOut Input & Output
///
typealias CheckOutViewModelType = CheckOutViewModelInput & CheckOutViewModelOutput

/// CheckOut ViewModel Input
///
protocol CheckOutViewModelInput {
 //   var cartCount:Int {get set}
    var productsId: [String] {get set}
    var orderID: Int? {get set}
    var selectedPaymentMethod: String? { get set }
    var visa: Visa? { get set }
}

/// CheckOut ViewModel Output
///
protocol CheckOutViewModelOutput {
    func getSectionItem (_ index: Int) -> CheckoutSectionsItem
    func getSectionsNumber() -> Int
    func getSectionHeaderInfo(_ index: Int) -> BookingSummerySectionsVM 
    func firstRequest() 
    func abandonedState(completion: @escaping (Bool) -> ())
    func reservation(completion: @escaping (Bool) -> ())
    func bookingConfirmation(completion: @escaping (Bool) -> ())
    func  PaymentConfirmation(name: String, visaNumber: String, month: String, year: String, cvc: String, total: String,completion: @escaping (Bool) -> ())
}
