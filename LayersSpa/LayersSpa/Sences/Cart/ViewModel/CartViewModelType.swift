//  
//  CartViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation

/// Cart Input & Output
///
typealias CartViewModelType = CartViewModelInput & CartViewModelOutput

/// Cart ViewModel Input
///
protocol CartViewModelInput {
    func getCartProductsList(_ type: CoreDataProductType)
    var onReloadData: (([ProductVM]) -> Void) {get set}
    var onReloadTotalPrice: (Double) -> Void { get set }
    var onReloadTotalCount: ((Int) -> Void) { get set }
    var productsViewModels: [ProductVM]{ get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var totalPrice: Double { get set }
    var totalCount: Int  { get set }
  //  var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var state: ViewState { get set }
}

/// Cart ViewModel Output
///
protocol CartViewModelOutput {
    func getProductssNum() -> Int
    func getProduct(_ index: Int) -> ProductVM
}
