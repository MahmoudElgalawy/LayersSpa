//
//  CategoriesUseCase.swift
//  LayersSpa
//
//  Created by Marwa on 19/08/2024.
//

import Foundation
import Networking
import UIKit

class CategoriesUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: CategoriesRemoteProtocol

    init(remote: CategoriesRemoteProtocol = CategoriesRemote(network: networking)) {
        self.remote = remote
    }
    
    func getCategoriesList(completion: @escaping (Result<[CategoriesVM], CustomError>) -> Void) {
        remote.getCategoriesData(completion: { result in
            switch result {
            case let .success(data):
                if data.status {
                    let categoriesData = data.data?.map { $0.toViewDataModel() }
                    completion(.success(categoriesData ?? []))
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

extension CategoriesData: ViewDataModelConvertible {
    public func toViewDataModel() -> CategoriesVM {
        return CategoriesVM(icon: image ?? "", title: alias ?? "", id: "\(id ?? 0)")
    }
}
