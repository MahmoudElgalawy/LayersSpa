//  
//  CartViewModel.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation

// MARK: CartViewModel

class CartViewModel {
    
    private var useCase: CartUseCase
    
    var totalPrice: Double = 0.0
    var totalCount: Int = 0
    
    init(useCase: CartUseCase = CartUseCase()) {
        self.useCase = useCase
    }
    
    var productsViewModels: [ProductVM] = [] {
        didSet {
            onReloadData(productsViewModels)
        }
    }
    
     var totalCartPrice: Double = 0 {
        didSet {
            onReloadTotalPrice(totalCartPrice)
        }
    }
    
    private var totalCartCount: Int = 0 {
        didSet {
            onReloadTotalCount(totalCartCount)
        }
    }
    
    var state: ViewState = .empty {
        didSet {
            onUpdateLoadingStatus(state)
        }
    }
    
    var onReloadData: (([ProductVM]) -> Void) = { _ in }
    var onReloadTotalPrice: ((Double) -> Void) = { _ in }
    var onReloadTotalCount: ((Int) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
}

// MARK: CartViewModel

extension CartViewModel: CartViewModelInput {
    
    func getCartProductsList(_ type: CoreDataProductType) {
        state = .loading // إضافة هذه السطر لتحديث الحالة إلى "loading"
        
        useCase.getProductsList(type) { [weak self] products in
            guard let self = self else { return }
            
            if products.isEmpty {
                self.state = .empty // تحديث الحالة إلى "empty" إذا كانت المنتجات فارغة
            } else {
                self.state = .loaded // تحديث الحالة إلى "loaded" بعد استرجاع البيانات
                self.calcTotalPrice(products)
                let ids = products.map { $0.productId }
                print(ids)
                let sortedProducts = products.sorted(by: { Int($0.productId) ?? 0 > Int($1.productId) ?? 0 })
                self.productsViewModels = sortedProducts
            }
        }
    }

}

// MARK: CartViewModelOutput

extension CartViewModel: CartViewModelOutput {
    
    func getProductssNum() -> Int {
        return productsViewModels.count
    }
    
    func getProduct(_ index: Int) -> ProductVM {
        return productsViewModels[index]
    }
}

// MARK: Private Handlers

private extension CartViewModel {
    func calcTotalPrice(_ cartData: [ProductVM]) {
        self.totalPrice = 0
        self.totalCount = 0
        for item in cartData {
            let price = Double(item.productPrice) ?? 0.0
            self.totalCount += item.productCount
            self.totalPrice += price * Double(item.productCount)
        }
        DispatchQueue.main.async {
            self.totalCartPrice = self.totalPrice
            self.totalCartCount = self.totalCount
        }
    }
}
