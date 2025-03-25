//
//  LoginUseCase.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Networking

class LoginUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: LoginRemoteProtocol

    init(remote: LoginRemoteProtocol = LoginRemote(network: networking)) {
        self.remote = remote
    }
    
    func login(_ phoneNumber: String, _ password: String, completion: @escaping (Result<loginVM, CustomError>) -> Void) {
        remote.Login(phoneNumber, password, completion: { result in
            switch result {
            case let .success(data):
                if data.status {
                    let domainList = data.toViewDataModel()
                    completion(.success(domainList))
                } else {
                    completion(.failure(.message(data.message)))
                }
                
            case let .failure(error):
                completion(.failure(.message(error.localizedDescription)))
            }
        })
    }
}

extension Login: ViewDataModelConvertible {
    public func toViewDataModel() -> loginVM {
        return loginVM(name: data?.userName ?? "", image: data?.image ?? "", phone: data?.phone ?? "", email: data?.email ?? "", token: data?.token ?? "", userId: data?.userID ?? -1)
    }
}

enum CustomError: Error {
    case message(String)
}

public struct loginVM: Codable {
    var name: String
    var image: String
    var phone: String
    var email: String
    var token: String
    var userId: Int
    
}

