//  
//  ForgotPasswordViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import Foundation

/// ForgotPassword Input & Output
///
typealias ForgotPasswordViewModelType = ForgotPasswordViewModelInput & ForgotPasswordViewModelOutput

/// ForgotPassword ViewModel Input
///
protocol ForgotPasswordViewModelInput {
    func resetPassword(_ email: String)
}

/// ForgotPassword ViewModel Output
///
protocol ForgotPasswordViewModelOutput {
    var onReloadData: ((CheckPhoneExistVM) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
}
