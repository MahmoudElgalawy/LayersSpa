//
//  SignupUseCase.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Networking

class SignupUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: SignupRemoteProtocol

    init(remote: SignupRemoteProtocol = SignupRemote(network: networking)) {
        self.remote = remote
    }
    
    func signup(_ phoneNumber: String, _ password: String, _ email: String, _ name: String, _ lang: String, completion: @escaping (Result<loginVM, CustomError>) -> Void) {
        remote.Signup(phoneNumber, password,email, name, lang, completion: { result in
            print(result)
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

extension Signup: ViewDataModelConvertible {
    public func toViewDataModel() -> loginVM {
        //return signupVM(name: data?.userName ?? "", phone: "" /*/"\(data?.phone ?? 0)"*/, email: /*data?.email ??*/ "", token: data?.token ?? "")
        
        return loginVM(name: data?.userName ?? "", image: "", phone: "" /*/"\(data?.phone ?? 0)"*/, email: /*data?.email ??*/ "", token: data?.token ?? "", userId: data?.userID ?? -1)
    }
}

public struct signupVM {
    let name: String
    let phone: String
    let email: String
    let token: String
}


