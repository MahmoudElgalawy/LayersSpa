//
//  HomeUseCase.swift
//  LayersSpa
//
//  Created by 2B on 16/08/2024.
//

import Foundation
import Networking
import UIKit

class HomeUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: HomeRemoteProtocol

    init(remote: HomeRemoteProtocol = HomeRemote()) {
        self.remote = remote
    }
    
    func getHomeData( _ branchId: String, completion: @escaping (Result<HomeVM, CustomError>) -> Void) {
        remote.getHomeData(branchId, completion: { result in
            switch result {
            case let .success(data):
                if data.status {
                    let homeData = data.toViewDataModel()
                    DispatchQueue.main.async {
                        completion(.success(homeData))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(.message(data.message)))
                    }
                }
                
            case let .failure(error):
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.message(error.localizedDescription)))
                }
            }
        })
    }
    
    
    func getBranches(completion: @escaping ( Result<AllBranchesVM, CustomError>) -> Void) {
        remote.getBranches(completion: { result in
            switch result {
            case let .success(data):
                if data.status {
                    let branches = data.toViewDataModel()
                    DispatchQueue.main.async {
                        completion(.success(branches))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(.message(data.message)))
                    }
                }
                
            case let .failure(error):
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(.message(error.localizedDescription)))
                }
            }
        })
    }
}

extension Home: ViewDataModelConvertible {
    
    func createViewData(_ product: Product, _ isService: Bool) -> ProductVM {
        return ProductVM(productImage: product.image ?? "", productName: product.descriptions?.first?.name ?? "", productSize: "", productPrice: product.customerPrice ?? "", productRating: 0.0, productRateNumber: 0, productId: "\(product.id ?? 0)", productCount: 1, isService: isService, branchesId: product.branchID ?? [], unit: product.unit?.value, type: product.type ?? "")
    }
    
    public func toViewDataModel() -> HomeVM {
        return HomeVM(
            services: data?.services.map { createViewData($0, true) },
            products: data?.products.map { createViewData($0, false)},
            categories: data?.categories.map { $0.toViewDataModel()}
        )
    }
}

extension DataCategory: ViewDataModelConvertible {
    public func toViewDataModel() -> CategoriesVM {
        return CategoriesVM(icon: image ?? "", title: descriptions?.first?.title ?? "", id: "\(id ?? 0)")
    }
}


extension Branch: ViewDataModelConvertible {
    public func toViewDataModel() -> BrancheVM {
        return BrancheVM(id: "\(id ?? 0)", name: name ?? "", address: "")
    }
}

extension Branches: ViewDataModelConvertible {
    public func toViewDataModel() -> AllBranchesVM {
        return AllBranchesVM(branches: data?.map{$0.branch?.toViewDataModel()} as! [BrancheVM])
    }
}

public struct HomeVM:Equatable {
    let services: [ProductVM]?
    let products: [ProductVM]?
    let categories: [CategoriesVM]?
}

public struct ProductVM: Codable, Equatable {

    let productImage: String
    let productName: String
    let productSize: String
    let productPrice: String
    let productRating: Float
    let productRateNumber: Int
    let productId: String
    var productCount: Int
    let isService: Bool
    let branchesId: [String]
    let unit: Int?
    let type:String
}

public struct CategoriesVM:Equatable {
    let icon: String
    let title: String
    let id: String
}

public struct AllBranchesVM:Equatable {
    let branches: [BrancheVM]
}

public struct BrancheVM: Codable,Equatable {
    let id: String
    let name: String
    let address: String
}
