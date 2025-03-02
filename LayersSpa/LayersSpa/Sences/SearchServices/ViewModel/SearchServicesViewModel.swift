//
//  SearchServicesViewModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 11/01/2025.
//

import Foundation
import Networking

protocol SearchServicesViewModelProtocol {
    func getAllServices()
    func getService(_ index: Int) -> ProductVM
    func getServicesNum() -> Int
    func filterServices(by searchText: String)
    var onReloadData: (() -> Void) { get set }
    var onShowNetworkErrorAlertClosure: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
    var state: ViewState { get set }
    var filteresServicesArray: [ProductVM] {get set}
    var servicesArray: [ProductVM] { get set }
}

// MARK: ServicesViewModel

class SearchServicesViewModel {
    private var useCase: SearchServicesUseCase
    var isService = true
    
    init(_ isService: Bool) {
        self.isService = isService
        self.useCase = SearchServicesUseCase(isService)
    }
    
    var servicesArray: [ProductVM] = [] {
        didSet {
            onReloadData()
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
    
    
    var onReloadData: (() -> Void) = {}
    var onShowNetworkErrorAlertClosure: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
    
  
}

// MARK: ServicesViewModel

extension SearchServicesViewModel: SearchServicesViewModelProtocol {
    func getAllServices() {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.getAllServices(completion: { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.state = .loaded
                    self?.servicesArray = data
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
    
    func getService(_ index: Int) -> ProductVM {
        return servicesArray[index]
    }
    
    func getServicesNum() -> Int {
        return servicesArray.count
    }
    
    func filterServices(by searchText: String){
        if searchText.isEmpty {
            servicesArray = filteresServicesArray
        }else{
            servicesArray = filteresServicesArray.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
        }
        onReloadData()
    }
}
