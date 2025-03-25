//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Alamofire
import Foundation

/// Represents a collection of Remote Endpoints
///
open class Remote {

    /// Networking Wrapper: Dependency Injection Mechanism, useful for Unit Testing purposes.
    ///
    let network: Network

    /// Designated Initializer.
    ///
    /// - Parameters:
    ///     - credentials: Credentials to be used in order to authenticate every request.
    ///     - network: Network Wrapper, in charge of actually enqueueing a given network request.
    ///
    public init(network: Network) {
        self.network = network
    }

    /// Enqueues the specified Network Request.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - decoder: Decoder entity that will be used to attempt to decode the Backend's Response.
    ///     - completion: Closure to be executed upon completion.
    ///

    public func enqueue<D: Decodable>(
        _ request: URLRequestConvertible,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<D, Error>) -> Void
    ) {
      //  print("Request: \(request)")
        network.responseData(for: request) { result in
            switch result {
            case let .success(data):
                print("Data received: \(String(data: data, encoding: .utf8) ?? "Unable to print data")")
                
                if let remoteError = RemoteErrorValidator.error(from: data) {
                    print("Remote Error : \(remoteError.localizedDescription)")
                    completion(.failure(remoteError))
                    return
                }
                
                do {
                    print(D.self)
                    let decoded = try decoder.decode(D.self, from: data)
                    print(decoded)
                    completion(.success(decoded))
                } catch let decodingError as DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type): \(context.debugDescription)")
                        print("Coding path: \(context.codingPath)")
                    case .valueNotFound(let value, let context):
                        print("Value not found for value \(value): \(context.debugDescription)")
                        print("Coding path: \(context.codingPath)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found: \(context.debugDescription)")
                        print("Coding path: \(context.codingPath)")
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                        print("Coding path: \(context.codingPath)")
                    @unknown default:
                        print("Unknown decoding error")
                    }
                    print("Raw Data (as String): \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
                    completion(.failure(decodingError))
                } catch {
                    print("Unknown error during decoding: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                
            case let .failure(failure):
                print("Network Error or Parsing: \(failure.localizedDescription)")
                completion(.failure(failure))
            }
        }
    }

}

