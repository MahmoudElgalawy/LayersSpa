//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Alamofire

/// Represents Fakestore.com Endpoint
///
public struct LayersApiRequest: URLRequestConvertible {

    /// HTTP Request Method
    ///
    let method: HTTPMethod

    /// URL base
    ///
    let base: String
    
    /// URL Path
    ///
    let path: String

    /// Parameters
    ///
    let parameters: [String: Any]
    
    /// Body
    ///
    let body: Data?

    /// Headers
    ///
    let headers: HTTPHeaders
    
    let encoderType: ParameterEncoding?
    
    //https://taccounting.vodoerp.com/api/customers/login_business_customer
    /// Designated Initializer.
    ///
    /// - Parameters:
    ///     - method: HTTP Method we should use.
    ///     - path: RPC that should be called.
    ///     - parameters: Collection of Key/Value parameters, to be forwarded to the Jetpack Connected site.

    public init( body: Data? = nil,method: HTTPMethod, base: String , path: String, parameters: [String: Any]? = nil, header: HTTPHeaders? = nil, encoderType: ParameterEncoding? = nil) {
        self.method = method
        self.base = base
        self.path = path
        self.parameters = parameters ?? [:]
        self.headers = header ?? [:]
        self.encoderType = encoderType
        self.body = body
    }

    /// Returns a URLRequest instance reprensenting the current FakeStore Request.
    ///
    public func asURLRequest() throws -> URLRequest {
        let url = URL(string: base + path)!
        var request = try URLRequest(url: url, method: method, headers: headers)
        if let body = body {
                   request.httpBody = body
               } else {
                   request = try encoder.encode(request, with: parameters)
               }
        print("encoder: ", encoder)
        return request
        
    }
}

// MARK: - SMS Request: Internal

//
private extension LayersApiRequest {

    /// Returns the Parameters Encoder
    ///
    var encoder: ParameterEncoding {
        
        get {
            if let encoderType = encoderType {
                return encoderType
            }
            
            return method == .get ? URLEncoding.queryString : URLEncoding.httpBody
           
        }
        
    }
}

