//
//  ServicesRemote.swift
//  LayersSpa
//
//  Created by Marwa on 27/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `Remote` mainly used for mocking.
///

public protocol ServicesRemoteProtocol {
    func getAllServicesByType(_ type: String, _ branchId: String, completion: @escaping (Result<Services, Error>) -> Void)
    func getCategoryServices(_ categoryId: String, completion: @escaping (Result<Services, Error>) -> Void)
    func getAllServices(_ branchId: String, completion: @escaping (Result<Services, Error>) -> Void)
}

public class ServicesRemote: ServicesRemoteProtocol {

    private let session: URLSession

    // تهيئة الـ URLSession
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    // MARK: - طلب جميع الخدمات حسب النوع
    public func getAllServicesByType(_ type: String, _ branchId: String, completion: @escaping (Result<Services, Error>) -> Void) {
        let path = "api/v1/ecomm_products"
        let baseURL = Settings.ecommerceApiBaseURL
        let parameters: [String: String] = [
            "type": type,
            "view": "list",
            "branch_id": branchId
        ]

        // بناء URL مع query parameters
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        // إعداد الطلب
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "secure-business-key": Settings.secureBusinessKey,
            "apiconnection": "appmobile",
            "apikey": "5f28583f26a1a",
            "lang": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]

        // تنفيذ الطلب
        executeRequest(request: request, completion: completion)
    }

    // MARK: - طلب جميع الخدمات
    public func getAllServices(_ branchId: String, completion: @escaping (Result<Services, Error>) -> Void) {
        let path = "api/v1/ecomm_products"
        let baseURL = Settings.ecommerceApiBaseURL
        let parameters: [String: String] = [
            "view": "list",
            "branch_id": branchId
        ]

        // بناء URL مع query parameters
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        // إعداد الطلب
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "secure-business-key": Settings.secureBusinessKey,
            "apiconnection": "appmobile",
            "apikey": "5f28583f26a1a",
            "lang": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]

        // تنفيذ الطلب
        executeRequest(request: request, completion: completion)
    }

    // MARK: - طلب الخدمات حسب الفئة
    public func getCategoryServices(_ categoryId: String, completion: @escaping (Result<Services, Error>) -> Void) {
        let path = "api/v1/ecomm_products"
        let baseURL = Settings.ecommerceApiBaseURL
        let parameters: [String: String] = [
            "type": "Service",
            "view": "list",
            "category_id": categoryId
        ]

        // بناء URL مع query parameters
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
            return
        }

        // إعداد الطلب
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "secure-business-key": Settings.secureBusinessKey,
            "apiconnection": "appmobile",
            "apikey": "5f28583f26a1a",
            "lang": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]

        // تنفيذ الطلب
        executeRequest(request: request, completion: completion)
    }

    // MARK: - تنفيذ الطلب العام
    private func executeRequest(request: URLRequest, completion: @escaping (Result<Services, Error>) -> Void) {
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
                let services = try decoder.decode(Services.self, from: data)
                completion(.success(services))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
