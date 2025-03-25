//
//  Request.swift
//  LayersSpa
//
//  Created by Mahmoud on 21/02/2025.
//


import Foundation
import Alamofire

protocol CustomerBalanceRemoteProtocol {
    func fetchCustomerBalance(completion: @escaping (Result<WalletModel, Error>) -> Void)
}

class CustomerBalanceRemote: CustomerBalanceRemoteProtocol {
    let baseURL = "https://taccounting.vodoerp.com"
    
    func fetchCustomerBalance(completion: @escaping (Result<WalletModel, Error>) -> Void) {
        let path = "/api/customers/customer_balance/\((Defaults.sharedInstance.userData?.userId) ?? 0)/1"
        let headers: HTTPHeaders = [
            "apikey": "efe2db322a53",
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]
        
        let url = "\(baseURL)\(path)"
        
        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")
        
        AF.request(url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: WalletModel.self) { response in
                switch response.result {
                case .success(let customerBalance):
                    print("✅ Success: \(customerBalance)")
                    completion(.success(customerBalance))
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
