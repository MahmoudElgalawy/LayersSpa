//
//  LoginRemote.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///
public protocol LoginRemoteProtocol {
    func Login(_ phoneNumber: String, _ password: String, completion: @escaping (Result<Login, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class LoginRemote: Remote, LoginRemoteProtocol {

    public func Login(_ phoneNumber: String, _ password: String, completion: @escaping (Result<Login, Error>) -> Void) {
        let path = "api/customers/login_business_customer?phone=\(phoneNumber)&password=\(password)"
        let parameters: Parameters = ["phone": phoneNumber,
                                      "password": password]
        
        let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters,header: [
            "secure-business-key": Settings.secureBusinessKey,
                 "apiconnection": "appmobile",
                 "apikey": "5f28583f26a1a",
                 "Accept-Language": "en",
                 "Platform": "ios",
                 "Platform-key": Settings.platformKey
        ])
        enqueue(request, completion: completion)
    }
}


//01010907051
//Mahmoud@99
//\(phoneNumber)
//\(password)
