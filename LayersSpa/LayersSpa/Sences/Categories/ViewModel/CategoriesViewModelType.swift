//  
//  CategoriesViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import Foundation

/// Categories Input & Output
///
typealias CategoriesViewModelType = CategoriesViewModelInput & CategoriesViewModelOutput

/// Categories ViewModel Input
///
protocol CategoriesViewModelInput {
    func getCategories()
    func getCategory(_ index: Int) -> CategoriesVM
    func getCategoriesNum() -> Int
}

/// Categories ViewModel Output
///
protocol CategoriesViewModelOutput {
    var onReloadData: (([CategoriesVM]) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
}
