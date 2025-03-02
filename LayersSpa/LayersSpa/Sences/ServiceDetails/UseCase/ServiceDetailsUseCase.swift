//
//  ServiceDetailsUseCase.swift
//  LayersSpa
//
//  Created by Marwa on 28/08/2024.
//

import Foundation
import Networking
import UIKit

class ServiceDetailsUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: ServiceDetailsRemoteProtocol

    init(remote: ServiceDetailsRemoteProtocol = ServiceDetailsRemote(network: networking)) {
        self.remote = remote
    }
    
    func getServiceDetails(_ serviceId: String, completion: @escaping (Result<ServiceDetailVM, CustomError>) -> Void) {
        remote.getServiceDetails(serviceId, completion: { result in
            switch result {
            case let .success(data):
                print(data)
                if data.status {
                    if let detail = data.data  {
                        print("details ---", detail)
                        let serviceDetails = detail.toViewDataModel()
                        completion(.success(serviceDetails))
                    } else {
                        completion(.failure(.message(data.message)))
                    }
                    
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

extension ServiceDetailsDataClass: ViewDataModelConvertible {
    public func toViewDataModel() -> ServiceDetailVM {
        return ServiceDetailVM(serviceName: descriptions?.first?.title ?? "", serviceImage: image ?? "", price: customerPrice ?? "", description:  descriptions?.first?.description ?? "", rating: 0.0, totalReviews: 0, branchId: branchID ?? [], reviews: [])
    }
}


public struct ServiceDetailVM {
    let serviceName: String
    let serviceImage: String
    let price: String
    let description: String
    let rating: Float
    let totalReviews: Int
    let branchId: [String]
    let reviews: [ReviewVM]
}

public struct ReviewVM {
    let userName: String
    let userImage: String
    let rating: Float
    let ratingDate: String
    let reviewDesc: String
}
