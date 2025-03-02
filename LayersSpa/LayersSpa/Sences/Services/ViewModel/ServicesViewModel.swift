//  
//  ServicesViewModel.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import Foundation
import Networking

// MARK: ServicesViewModel

class ServicesViewModel {
    private var useCase: ServicesUseCase
    var isService = true
    
    init(_ isService: Bool) {
        self.isService = isService
        self.useCase = ServicesUseCase(isService)
    }
    
     var servicesViewModels: [ProductVM] = [] 
    
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
    
    
    var onReloadData: (([ProductVM]) -> Void) = { _ in }
    var onShowNetworkErrorAlertClosure: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
    
  
}

// MARK: ServicesViewModel

extension ServicesViewModel: ServicesViewModelInput {
    
    func getAllServices(_ type: String,branchId:String) {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.getAllServices(type, branchId: branchId, completion: {[weak self] result in
            switch result {
            case .success(let data):
                self?.state = .loaded
                self?.servicesViewModels = data
                self?.onReloadData(self?.servicesViewModels ?? [])
                
            case .failure(let error):
                switch error {
                case .message(let errorDesc):
                    self?.state = .error
                    self?.alertNetworkErrorMessage = errorDesc
                    
                }
            }
        })
    }
}

// MARK: ServicesViewModelOutput

extension ServicesViewModel: ServicesViewModelOutput {
    func getService(_ index: Int) -> ProductVM {
        return servicesViewModels[index]
    }
    
    func getServicesNum() -> Int {
        return servicesViewModels.count
    }
}

// MARK: Private Handlers

private extension ServicesViewModel {}
