//  
//  SignupViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import Foundation

/// Signup Input & Output
///
typealias SignupViewModelType = SignupViewModelInput & SignupViewModelOutput

/// Signup ViewModel Input
///
protocol SignupViewModelInput {
    func checkPhoneExist(_ phoneNumber: String, completion: @escaping ()->())
}

/// Signup ViewModel Output
///
protocol SignupViewModelOutput {
    var onReloadData: ((CheckPhoneExistVM) -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
    var exist: String? { get set }
}
