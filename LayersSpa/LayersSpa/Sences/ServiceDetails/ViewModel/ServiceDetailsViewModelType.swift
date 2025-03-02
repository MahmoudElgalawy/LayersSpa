//  
//  ServiceDetailsViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 11/08/2024.
//

import Foundation

/// ServiceDetails Input & Output
///
typealias ServiceDetailsViewModelType = ServiceDetailsViewModelInput & ServiceDetailsViewModelOutput

/// ServiceDetails ViewModel Input
///
protocol ServiceDetailsViewModelInput {
    var onReloadData: ((ServiceDetailVM) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
}

/// ServiceDetails ViewModel Output
///
protocol ServiceDetailsViewModelOutput {
    func getSectionItem (_ index: Int) -> ServiceDetailsTableViewSectionsItem
    func getSectionsNumber() -> Int
    func getServiceDetails(_ serviceId: String)
}
