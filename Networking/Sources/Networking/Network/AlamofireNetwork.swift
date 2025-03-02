//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Alamofire
import Foundation

/// AlamofireWrapper: Encapsulates all of the Alamofire OP's
///
public class AlamofireNetwork: Network {

    public init() {}

    /// Executes the specified Network Request. Upon completion, the payload will be sent back to the caller as a Data instance.
    ///
    public func responseData(for request: URLRequestConvertible, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(request).responseData { response in
            completion(response.result.toSwiftResult())
        }
    }
}

// MARK: - Swift.Result Conversion

//
private extension Result where Failure == AFError {
    /// Convert this `Alamofire.Result` to a `Swift.Result`.
    ///
    func toSwiftResult() -> Swift.Result<Success, Error> {
        switch self {
        case let .success(value):
            return .success(value)
        case let .failure(error):
            return .failure(error)
        }
    }
}


