//  
//  CategoryDetailsViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import Foundation

/// CategoryDetails Input & Output
///
typealias CategoryDetailsViewModelType = CategoryDetailsViewModelInput & CategoryDetailsViewModelOutput

/// CategoryDetails ViewModel Input
///
protocol CategoryDetailsViewModelInput {
    func getCategoryServices(_ categoryId: String)
    func getService(_ index: Int) -> ProductVM
    func getServicesNum() -> Int
    func filterServices(by searchText: String)
}

/// CategoryDetails ViewModel Output
///
protocol CategoryDetailsViewModelOutput {
    var onReloadData: (([ProductVM]) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
}
