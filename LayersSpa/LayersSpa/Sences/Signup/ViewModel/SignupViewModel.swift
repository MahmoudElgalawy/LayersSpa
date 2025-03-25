//  
//  SignupViewModel.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import Foundation
import Networking

// MARK: SignupViewModel

class SignupViewModel {
    private var useCase: CheckPhoneExistUseCase
    var remote: VerficationRemoteProtocol!
    
    init(useCase: CheckPhoneExistUseCase = CheckPhoneExistUseCase(), remote: VerficationRemoteProtocol = VerficationRemote(network: AlamofireNetwork())) {
        self.useCase = useCase
        self.remote = remote
    }
    
    private var checkPhoneExistViewModels: CheckPhoneExistVM? {
        didSet {
            onReloadData(checkPhoneExistViewModels!)
        }
    }
    
    var exist:String?
    
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


// MARK: SignupViewModel

extension SignupViewModel: SignupViewModelInput {
    func checkPhoneExist(_ phoneNumber: String, completion: @escaping ()->()) {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.checkPhoneExist(phoneNumber) { result in
            switch result {
            case .success(let data):
                self.state = .loaded
                self.checkPhoneExistViewModels = data
                self.exist = data.msg
                completion()
            case .failure(let error):
                switch error {
                case .message(let errorDesc):
                    self.state = .error
                    self.alertNetworkErrorMessage = errorDesc
                    
                }
            }
        }
    }
    
    func getOTP(phone: String){
        remote.getOTP(phone) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: SignupViewModelOutput

extension SignupViewModel: SignupViewModelOutput {}

// MARK: Private Handlers

private extension SignupViewModel {}
