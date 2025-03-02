//
//  SearchServicesViewModel.swift
//  LayersSpa
//
//  Created by Mahmoud on 11/01/2025.
//
import Foundation
import Networking
import UIKit



class SearchServicesUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: ServicesRemoteProtocol
    var isService = true

    init(remote: ServicesRemoteProtocol = ServicesRemote(), _ isService: Bool) {
        self.remote = remote
        self.isService = isService
    }
    
    func getAllServices(completion: @escaping (Result<[ProductVM], CustomError>) -> Void) {
        remote.getAllServices(Defaults.sharedInstance.branchId?.id ?? "", completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                if data.status {
                    let services = data.data?.map { self.createViewData($0, self.isService) }
                    completion(.success(services ?? []))
                } else {
                    completion(.failure(.message(data.message)))
                }
                
            case let .failure(error):
                print(error)
                completion(.failure(.message(error.localizedDescription)))
            }
        })
    }
}

extension SearchServicesUseCase {
    func createViewData(_ product: ServicesData, _ isService: Bool) -> ProductVM {
        return ProductVM(productImage: product.image ?? "", productName: product.descriptions?.first?.name ?? "", productSize: "", productPrice: product.customerPrice ?? "", productRating: 0.0, productRateNumber: 0, productId: "\(product.id ?? 0)", productCount: 1, isService: isService, branchesId: [product.branchID?.first ?? ""], unit: product.unit?.value, type: product.type ?? "")
    }
}

