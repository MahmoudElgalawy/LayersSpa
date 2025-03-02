//  
//  LikesViewModel.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import Foundation

// MARK: LikesViewModel

class LikesViewModel {
    
    private var useCase: LikeUseCase
    
    init(useCase: LikeUseCase = LikeUseCase()) {
        self.useCase = useCase
    }
    
    private var productsViewModels: [ProductVM] = [] {
        didSet {
            onReloadData(productsViewModels)
        }
    }
    
     var servicesViewModels: [ProductVM] = [] {
        didSet {
            onReloadData(servicesViewModels)
        }
    }

    var onReloadData: (([ProductVM]) -> Void) = { _ in } 
}

// MARK: LikesViewModel

extension LikesViewModel: LikesViewModelInput {
    func getLikeProductsList(_ type: CoreDataProductType) {
        useCase.getProductsList(type) { [weak self] products in
            guard let self = self else {return}
            if type == .product {
                self.productsViewModels = products
                print("product count : ", productsViewModels)
            }else if type == .service {
                self.servicesViewModels = products
                print("serviec count : ", servicesViewModels)
            }
            
        }
    }
}

// MARK: LikesViewModelOutput

extension LikesViewModel: LikesViewModelOutput {
    
    func getServicesNum() -> Int {
        return servicesViewModels.count
    }
    
    func getProductssNum() -> Int {
        return productsViewModels.count
    }
    
    func getService(_ index: Int) -> ProductVM  {
        return servicesViewModels[index]
    }
    
    func getProduct(_ index: Int) -> ProductVM {
        return productsViewModels[index]
    }
    
}

// MARK: Private Handlers

private extension LikesViewModel {}
