//
//  ServiceDetailsRemote.swift
//  LayersSpa
//
//  Created by Marwa on 28/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `Remote` mainly used for mocking.
///
public protocol ServiceDetailsRemoteProtocol {
    func getServiceDetails(_ serviceId: String, completion: @escaping (Result<ServiceDetails, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class ServiceDetailsRemote: Remote, ServiceDetailsRemoteProtocol {

    public func getServiceDetails(_ serviceId: String, completion: @escaping (Result<ServiceDetails, Error>) -> Void) {
        let path = "api/v1/ecomm_products/\(serviceId)"
        
        let headers: HTTPHeaders = [
            "secure-business-key": Settings.secureBusinessKey,
            "apiconnection": "appmobile",
            "apikey": "5f28583f26a1a",
            "Accept-Language": "en"
        ]
        
        
        let request = LayersApiRequest(method: .get, base: Settings.ecommerceApiBaseURL, path: path, header: headers)
        enqueue(request, completion: completion)
    }
}



