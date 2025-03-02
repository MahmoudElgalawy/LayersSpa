//
//  SaveCartProductsRemote.swift
//  LayersSpa
//
//  Created by 2B on 15/09/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///
public protocol CartRemoteProtocol {
    func SaveCartProducts(_ userId: String, _ productsId: [String], _ itemsQty: [Int], completion: @escaping (Result<SaveCartProducts, Error>) -> Void)
    
    func getCartProducts(_ userId: String, completion: @escaping (Result<GetCartProducts, Error>) -> Void)
    
    func deleteCartProduct(_ userId: String, _ productId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class CartRemote: Remote, CartRemoteProtocol {
    
    let path = "api/v2/abandoned_order"
    
    public func getCartProducts(_ userId: String, completion: @escaping (Result<GetCartProducts, any Error>) -> Void) {
//        let parameters: Parameters = [
//            "user_id": userId,
//            "product_id":productsId,
//            "item_qty": itemsQty
//        ]
        
        let header: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "user-id": userId,
            "lang": "en"
        ]

        
        let request = LayersApiRequest(method: .get, base: Settings.ecommerceApiBaseURL, path: path, header: header)
        
        print("request :", request)
        enqueue(request, completion: completion)
    }
    

    public func SaveCartProducts(_ userId: String, _ productsId: [String], _ itemsQty: [Int], completion: @escaping (Result<SaveCartProducts, Error>) -> Void) {
        
        let parameters: Parameters = [
            "user_id": userId,
            "product_id":productsId,
            "item_qty": itemsQty
        ]
        let header: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130", //728106399db2b289783.89154521
            "lang": "en"
        ]

        
        let request = LayersApiRequest(method: .post, base: Settings.ecommerceApiBaseURL, path: path, parameters: parameters, header: header, encoderType: JSONEncoding.default)
        
        print("request :", request)
        enqueue(request, completion: completion)
    }
    
    public func deleteCartProduct(_ userId: String, _ productId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let path = "api/v2/abandoned_order"
        let parameters: Parameters = [
            "user_id": userId,
            "product_id": productId
        ]
        
        let header: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "lang": "en"
        ]
        
        let request = LayersApiRequest(method: .delete, base: Settings.ecommerceApiBaseURL, path: path, parameters: parameters, header: header, encoderType: JSONEncoding.default)
            
        enqueue(request) { (result: Result<Data, Error>) in
            switch result {
            case .success:
                print("Product deleted successfully")
                completion(.success(()))
            case .failure(let error):
                print("Failed to delete product:", error)
                completion(.failure(error))
            }
        }
    }

}

