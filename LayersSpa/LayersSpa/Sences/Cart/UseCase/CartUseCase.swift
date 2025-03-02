//
//  CartUseCase.swift
//  LayersSpa
//
//  Created by Marwa on 03/09/2024.
//

import Foundation
import Networking

class CartUseCase {
    
    private static var networking: Network = AlamofireNetwork()
    let remote: CartRemoteProtocol

    init(remote: CartRemoteProtocol = CartRemote(network: networking)) {
        self.remote = remote
    }
    
//    func saveCartProducts(_ userId: String, _ productsId: [String], _ itemsQty: [Int], completion: @escaping(Result<Bool, CustomError>) -> Void) {
//        print("userId ===================================+++++++++++++++++++++++++++++==============\(userId)")
//        remote.SaveCartProducts(userId, productsId, itemsQty) { result in
//            print(result)
//            switch result {
//            case let .success(data):
//                completion(.success(data.status))
//            case let .failure(error):
//                completion(.failure(.message(error.localizedDescription)))
//            }
//        }
//    }
    
//    func getCartProducts(_ userId: String, completion: @escaping(Result<[ProductVM], CustomError>) -> Void) {
//        remote.getCartProducts(userId) { result in
//            print(result)
//            switch result {
//            case let .success(data):
//                let products = data.data.details?.map {$0.toViewDataModel() }
//                completion(.success(products ?? []))
//            case let .failure(error):
//                completion(.failure(.message(error.localizedDescription)))
//            }
//        }
//    }
    
    func getProductsList(_ type: CoreDataProductType, completion: @escaping (([ProductVM]) -> Void)) {
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(type) { data in
            completion(data)
        }
    }
    
//    func deleteCartProduct(_ userId: String, _ productId: String, completion: @escaping (Result<Void, CustomError>) -> Void) {
//            remote.deleteCartProduct(userId, productId) { result in
//                switch result {
//                case .success:
//                    print("Product deleted successfully")
//                    completion(.success(()))
//                case let .failure(error):
//                    print("Failed to delete product:", error)
//                    completion(.failure(.message(error.localizedDescription)))
//                }
//            }
//        }
    
    
}
//
//extension Detail: ViewDataModelConvertible {
//    func toViewDataModel() -> ProductVM {
//        return ProductVM(productImage: product.image ?? "", productName: name ?? "", productSize: "", productPrice: "\(totalPrice ?? 0)", productRating: 0.0, productRateNumber: 0, productId: "\(id ?? -1)", productCount: qty ?? 0, isService: true, branchesId: product.branchID ?? [], type: p)
//        // is service neeed to be edit
//    }
//}
//
