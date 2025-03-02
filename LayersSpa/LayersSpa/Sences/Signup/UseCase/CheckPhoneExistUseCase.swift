//
//  CheckPhoneExistUseCase.swift
//  LayersSpa
//
//  Created by Marwa on 26/08/2024.
//

import Foundation
import Networking

class CheckPhoneExistUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: CheckPhoneExistRemoteProtocol

    init(remote: CheckPhoneExistRemoteProtocol = CheckPhoneExistRemote(network: networking)) {
        self.remote = remote
    }
    
    func checkPhoneExist(_ phoneNumber: String, completion: @escaping (Result<CheckPhoneExistVM, CustomError>) -> Void) {
        remote.checkPhoneExist(phoneNumber, completion: { result in
            switch result {
            case let .success(data):
                if data.status {
                    let result = data.toViewDataModel()
                    completion(.success(result))
                } else {
                    completion(.failure(.message(data.message)))
                }
                
            case let .failure(error):
                completion(.failure(.message(error.localizedDescription)))
            }
        })
    }
}

extension CheckPhoneExist: ViewDataModelConvertible {
    public func toViewDataModel() -> CheckPhoneExistVM {
        return CheckPhoneExistVM(state: status, msg: message)
    }
}

public struct CheckPhoneExistVM {
    let state: Bool
    let msg: String
}

