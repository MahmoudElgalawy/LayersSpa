//  
//  ForgotPasswordViewModel.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import Foundation
import Networking

// MARK: ForgotPasswordViewModel

class ForgotPasswordViewModel {
    private var useCase: ResetPasswordUseCase
    
    init(useCase: ResetPasswordUseCase = ResetPasswordUseCase()) {
        self.useCase = useCase
    }
    
    private var resetPasswordViewModels: CheckPhoneExistVM? {
        didSet {
            onReloadData(resetPasswordViewModels!)
        }
    }
    
    var state: ViewState = .empty {
        didSet {
            onUpdateLoadingStatus(state)
        }
    }
    
    var alertNetworkErrorMessage: String = "" {
        didSet {
            onShowNetworkErrorAlertClosure(alertNetworkErrorMessage)
        }
    }
    
    
    var onReloadData: ((CheckPhoneExistVM) -> Void) = { _ in }
    var onShowNetworkErrorAlertClosure: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
}

// MARK: ForgotPasswordViewModel

extension ForgotPasswordViewModel: ForgotPasswordViewModelInput {
    func resetPassword(_ email: String) {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.resetPassword(email) { result in
            switch result {
            case .success(let data):
                if data.state{
                    self.state = .loaded
                    self.resetPasswordViewModels = data
                }else{
                    self.state = .error
                    self.alertNetworkErrorMessage = "Phone is not exist"
                }
                
            case .failure(let error):
                switch error {
                case .message(let errorDesc):
                    self.state = .error
                    self.alertNetworkErrorMessage = errorDesc
                    
                }
            }
        }
    }
}

// MARK: ForgotPasswordViewModelOutput

extension ForgotPasswordViewModel: ForgotPasswordViewModelOutput {}

// MARK: Private Handlers

private extension ForgotPasswordViewModel {}
