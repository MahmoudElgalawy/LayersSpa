//
//  SignupRemote.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///
public protocol SignupRemoteProtocol {
    func Signup(_ phoneNumber: String, _ password: String, _ email: String, _ name: String, _ lang: String, completion: @escaping (Result<Signup, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class SignupRemote: Remote, SignupRemoteProtocol {

    public func Signup(_ phoneNumber: String, _ password: String, _ email: String, _ name: String, _ lang: String, completion: @escaping (Result<Signup, Error>) -> Void) {
        
        let path = "api/customers/store_business_customer"
        let parameters: Parameters = [
            "phone": phoneNumber,
            "password": password,
            "email": email,
            "name": name
        ]
        
        let header: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "platform": "android",
            "platform-key": "387666a26a0ad869c9.00802837",
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]

        
        let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters, header: header)
        enqueue(request, completion: completion)
    }
}

