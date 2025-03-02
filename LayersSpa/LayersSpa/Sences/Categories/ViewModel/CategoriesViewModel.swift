//  
//  CategoriesViewModel.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import Foundation
import Networking

// MARK: CategoriesViewModel

class CategoriesViewModel {
    
    private var useCase: CategoriesUseCase
    
    init(useCase: CategoriesUseCase = CategoriesUseCase()) {
        self.useCase = useCase
    }
    
    private var categoriesViewModels: [CategoriesVM] = [] {
        didSet {
            onReloadData(categoriesViewModels)
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
    
    
    var onReloadData: (([CategoriesVM]) -> Void) = { _ in }
    var onShowNetworkErrorAlertClosure: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
    
  
}

// MARK: CategoriesViewModel

extension CategoriesViewModel: CategoriesViewModelInput {
    func getCategories() {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.getCategoriesList(completion: { result in
            switch result {
            case .success(let data):
                self.state = .loaded
                self.categoriesViewModels = data
                
            case .failure(let error):
                switch error {
                case .message(let errorDesc):
                    self.state = .error
                    self.alertNetworkErrorMessage = errorDesc
                    
                }
            }
        })
    }
}

// MARK: CategoriesViewModelOutput

extension CategoriesViewModel: CategoriesViewModelOutput {
    func getCategory(_ index: Int) -> CategoriesVM{
        return categoriesViewModels[index]
    }
    
    func getCategoriesNum() -> Int {
        return categoriesViewModels.count
    }
}

// MARK: Private Handlers

private extension CategoriesViewModel {}
