//
//  CategoriesRemote.swift
//  LayersSpa
//
//  Created by Marwa on 19/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `Remote` mainly used for mocking.
///
public protocol CategoriesRemoteProtocol {
    func getCategoriesData(completion: @escaping (Result<Categories, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class CategoriesRemote: Remote, CategoriesRemoteProtocol {

    public func getCategoriesData(completion: @escaping (Result<Categories, Error>) -> Void) {
        let path = "api/v1/ecomm_categories"
        let parameters: Parameters = ["view": "list"]
        
        let headers: HTTPHeaders = [
            "secure-business-key": Settings.secureBusinessKey,
                 "apiconnection": "appmobile",
                 "apikey": "5f28583f26a1a",
                 "Accept-Language": "ar",
                 "Platform": "ios",
                 "Platform-key": Settings.platformKey
        ]
        
        //https://testecommerce.vodoglobal.com/api/v1/ecomm_categories
        let request = LayersApiRequest(method: .get, base: Settings.ecommerceApiBaseURL, path: path, parameters: parameters, header: headers)
        enqueue(request, completion: completion)
    }
}


