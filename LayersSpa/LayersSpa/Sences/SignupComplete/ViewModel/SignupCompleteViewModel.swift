//  
//  SignupCompleteViewModel.swift
//  LayersSpa
//
//  Created by marwa on 19/07/2024.
//

import Foundation
import Networking

// MARK: SignupCompleteViewModel

class SignupCompleteViewModel {
    private var useCase: SignupUseCase
    
    init(useCase: SignupUseCase = SignupUseCase()) {
        self.useCase = useCase
    }
    
    private var signupViewModels: loginVM? {
        didSet {
            onReloadData(signupViewModels!)
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

// MARK: SignupCompleteViewModel

extension SignupCompleteViewModel: SignupCompleteViewModelInput {
    func userSignup(_ phoneNumber: String, _ password: String, _ email: String, _ name: String, _ lang: String = "en") {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.signup(phoneNumber, password, email, name, lang ) { result in
            switch result {
            case .success(let data):
                self.state = .loaded
                Defaults.sharedInstance.userData = data
                UserDefaults.standard.set(data.image, forKey: "image")
                self.signupViewModels = data
                
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

// MARK: SignupCompleteViewModelOutput

extension SignupCompleteViewModel: SignupCompleteViewModelOutput {}

// MARK: Private Handlers

private extension SignupCompleteViewModel {}
