//
//  CategoryDetailsUsecase.swift
//  LayersSpa
//
//  Created by Marwa on 28/08/2024.
//

import Foundation
import Networking
import UIKit
import Alamofire


class CategoryDetailsUsecase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: ServicesRemoteProtocol

    init(remote: ServicesRemoteProtocol = ServicesRemote()) {
        self.remote = remote
    }
    
    func getCategoryServices(_ categoryId: String, completion: @escaping (Result<[ProductVM], CustomError>) -> Void) {
        remote.getCategoryServices(categoryId, completion: { result in
            switch result {
            case let .success(data):
                if data.status {
                    let services = data.data?.map { $0.toViewDataModel() }
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

extension ServicesData: ViewDataModelConvertible {
    public func toViewDataModel() -> ProductVM {
        return ProductVM(productImage: image ?? "", productName: descriptions?.first?.name ?? "", productSize: "", productPrice: customerPrice ?? "", productRating: 0.0, productRateNumber: 0, productId: "\(id ?? 0)", productCount: 1, isService: true, branchesId: [branchID?.first ?? ""], unit: unit?.value, type: type ?? "")
    }
}
