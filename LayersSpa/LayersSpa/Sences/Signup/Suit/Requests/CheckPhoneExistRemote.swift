//
//  CheckPhoneExistRemote.swift
//  LayersSpa
//
//  Created by Marwa on 26/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///
public protocol CheckPhoneExistRemoteProtocol {
    func checkPhoneExist(_ phoneNumber: String, completion: @escaping (Result<CheckPhoneExist, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class CheckPhoneExistRemote: Remote, CheckPhoneExistRemoteProtocol {

    public func checkPhoneExist(_ phoneNumber: String, completion: @escaping (Result<CheckPhoneExist, Error>) -> Void) {
        let path = "api/customers/phone_exist"
      
        let parameters: Parameters = ["phone": phoneNumber]
        let headers: HTTPHeaders = ["apikey": "efe2db322a53", "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)", "secure-business-key": Settings.secureBusinessKey, "Platform": "ios",
                                    "Platform-key": Settings.platformKey]
        
        let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters, header: headers)
        
        enqueue(request, completion: completion)
    }
}



