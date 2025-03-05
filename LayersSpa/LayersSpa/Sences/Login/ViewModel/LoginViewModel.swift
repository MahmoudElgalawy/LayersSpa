//  
//  LoginViewModel.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import Foundation
import Networking

// MARK: LoginViewModel

class LoginViewModel {
    private var useCase: LoginUseCase
    
    init(useCase: LoginUseCase = LoginUseCase()) {
        self.useCase = useCase
    }
    
    var isLoggedIn: Bool {
        get {
            return Defaults.sharedInstance.isLoggedIn() // تحقق من حالة تسجيل الدخول
        }
    }
    
    private var loginViewModels: loginVM? {
        didSet {
            onReloadData(loginViewModels!)
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
    
    
    var onReloadData: ((loginVM) -> Void) = { _ in }
    var onShowNetworkErrorAlertClosure: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
    
    
}

// MARK: LoginViewModel

extension LoginViewModel: LoginViewModelInput {
    func userLogin(_ phoneNumber: String, _ password: String) {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.login(phoneNumber, password) { result in
            switch result {
            case .success(let data):
                self.state = .loaded
                Defaults.sharedInstance.userData = data
                UserDefaults.standard.set(data.image, forKey: "image")
                Defaults.sharedInstance.login()
                self.loginViewModels = data
                
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

// MARK: LoginViewModelOutput

extension LoginViewModel: LoginViewModelOutput {}

// MARK: Private Handlers

private extension LoginViewModel {}

enum ViewState {
    case empty
    case loading
    case error
    case loaded
}

