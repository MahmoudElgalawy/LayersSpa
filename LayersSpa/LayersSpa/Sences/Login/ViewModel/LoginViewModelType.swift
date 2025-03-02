//  
//  LoginViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import Foundation

/// Login Input & Output
///
typealias LoginViewModelType = LoginViewModelInput & LoginViewModelOutput

/// Login ViewModel Input
///
protocol LoginViewModelInput {
    func userLogin(_ phoneNumber: String, _ password: String)
}

/// Login ViewModel Output
///
protocol LoginViewModelOutput {
    var onReloadData: ((loginVM) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
    var isLoggedIn: Bool { get } 
}


