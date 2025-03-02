//  
//  SignupCompleteViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 19/07/2024.
//

import Foundation

/// SignupComplete Input & Output
///
typealias SignupCompleteViewModelType = SignupCompleteViewModelInput & SignupCompleteViewModelOutput

/// SignupComplete ViewModel Input
///
protocol SignupCompleteViewModelInput {
    func userSignup(_ phoneNumber: String, _ password: String, _ email: String, _ name: String, _ lang: String)
}

/// SignupComplete ViewModel Output
///
protocol SignupCompleteViewModelOutput {
    var onReloadData: ((loginVM) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
}
