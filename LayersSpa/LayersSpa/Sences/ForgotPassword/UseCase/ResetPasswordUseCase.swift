//
//  ResetPasswordUseCase.swift
//  LayersSpa
//
//  Created by Marwa on 26/08/2024.
//

import Foundation
import Networking

class ResetPasswordUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: ResetPasswordRemoteProtocol

    init(remote: ResetPasswordRemoteProtocol = ResetPasswordRemote(network: networking)) {
        self.remote = remote
    }
    
    func resetPassword(_ email: String, completion: @escaping (Result<CheckPhoneExistVM, CustomError>) -> Void) {
        remote.resetPassword(email, completion: { result in
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

extension ResetPassword: ViewDataModelConvertible {
    public func toViewDataModel() -> CheckPhoneExistVM {
        return CheckPhoneExistVM(state: status, msg: message)
    }
}

