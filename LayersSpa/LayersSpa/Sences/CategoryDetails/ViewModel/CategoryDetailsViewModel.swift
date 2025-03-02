//  
//  CategoryDetailsViewModel.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import Foundation
import Networking

// MARK: CategoryDetailsViewModel

class CategoryDetailsViewModel {
    private var useCase: CategoryDetailsUsecase
    
    init(useCase: CategoryDetailsUsecase = CategoryDetailsUsecase()) {
        self.useCase = useCase
    }
    
    private var servicesViewModels: [ProductVM] = [] {
        didSet {
            onReloadData(servicesViewModels)
        }
    }
    var filteresServicesArray: [ProductVM] = []
    
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

// MARK: CategoryDetailsViewModel

extension CategoryDetailsViewModel: CategoryDetailsViewModelInput {
    func getCategoryServices(_ categoryId: String) {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.getCategoryServices(categoryId, completion: { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.state = .loaded
                    self?.servicesViewModels = data
                    self?.filteresServicesArray = data
                    
                }
            case .failure(let error):
                switch error {
                case .message(let errorDesc):
                    DispatchQueue.main.async {
                        self?.state = .error
                        self?.alertNetworkErrorMessage = errorDesc
                    }
                    
                }
            }
        })
    }
}

// MARK: CategoryDetailsViewModelOutput

extension CategoryDetailsViewModel: CategoryDetailsViewModelOutput {
    func getService(_ index: Int) -> ProductVM {
        return servicesViewModels[index]
    }
    
    func getServicesNum() -> Int {
        return servicesViewModels.count
    }
    
    func filterServices(by searchText: String){
        if searchText.isEmpty {
            servicesViewModels = filteresServicesArray
        }else{
            servicesViewModels = filteresServicesArray.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
            onReloadData(servicesViewModels)
        }
    }
}

// MARK: Private Handlers

private extension CategoryDetailsViewModel {}
