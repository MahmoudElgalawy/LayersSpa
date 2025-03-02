//  
//  ServicesViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import Foundation

/// Services Input & Output
///
typealias ServicesViewModelType = ServicesViewModelInput & ServicesViewModelOutput

/// Services ViewModel Input
///
 protocol ServicesViewModelInput {
    func getAllServices(_ type: String,branchId:String)
    func getService(_ index: Int) -> ProductVM
    func getServicesNum() -> Int
}

/// Services ViewModel Output
///
protocol ServicesViewModelOutput {
    var onReloadData: (([ProductVM]) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
    var servicesViewModels: [ProductVM] { get set }
}
