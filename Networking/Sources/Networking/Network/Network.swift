//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Alamofire
import Foundation

public protocol Network {

    /// Executes the specified Network Request. Upon completion, the payload will be sent back to the caller as a Data instance.
    ///
    func responseData(for request: URLRequestConvertible, completion: @escaping (Result<Data, Error>) -> Void)
}

