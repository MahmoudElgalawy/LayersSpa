//
//  HomeRequest.swift
//  LayersSpa
//
//  Created by 2B on 16/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///

public protocol HomeRemoteProtocol {
    func getHomeData(_ branchId: String, completion: @escaping (Result<Home, Error>) -> Void)
    func getBranches(completion: @escaping (Result<Branches, Error>) -> Void)
}

public class HomeRemote: HomeRemoteProtocol {

    private let session: URLSession

    public init(session: URLSession = {
        let configuration = URLSessionConfiguration.default
       // configuration.timeoutIntervalForRequest = 60
       // configuration.timeoutIntervalForResource = 20
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return URLSession(configuration: configuration)
    }()) {
        self.session = session
    }

    public func getHomeData(_ branchId: String, completion: @escaping (Result<Home, Error>) -> Void) {
        let path = "api/reservation_app_home"
        let baseURL = Settings.ecommerceApiBaseURL
        let parameters: [String: String] = ["branch_id": branchId]

        guard var urlComponents = URLComponents(string: baseURL + path) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        let savedLanguages = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String //as? [String],
//           let savedLanguage = savedLanguages.first {
//            print("Saved language: \(savedLanguage)")
//        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "secure-business-key": Settings.secureBusinessKey,
            "platform": Settings.platform,
            "platform-key": Settings.platformKey,
            "Accept-Language": "\((savedLanguages)!)"
        ]
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
               // decoder.keyDecodingStrategy = .convertFromSnakeCase
                let homeData = try decoder.decode(Home.self, from: data)
               // print("The Home Data ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> : \(homeData)")
                completion(.success(homeData))
            } catch {
                completion(.failure(error))
            }
        }
        
//        for metric in metrics.transactionMetrics {
//            print(task.response?.url ?? "", metric.fetchStartDate?.description(with: .current) ?? "")
//        }
        task.resume()
    }

    public func getBranches(completion: @escaping (Result<Branches, Error>) -> Void) {
        let path = "api/reservation_branches"
        let baseURL = Settings.accountApiBaseURL

        guard let url = URL(string: baseURL + path) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "business-secure-key": Settings.secureBusinessKey,
            "lang": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: -1, userInfo: nil)))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let branchesData = try decoder.decode(Branches.self, from: data)
                completion(.success(branchesData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
