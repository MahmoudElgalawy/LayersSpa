//
//  LikeUseCase.swift
//  LayersSpa
//
//  Created by Marwa on 01/09/2024.
//

import Foundation

class LikeUseCase {
    
    func getProductsList(_ type: CoreDataProductType, completion: @escaping (([ProductVM]) -> Void)) {
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(type) { data in
            completion(data)
        }
    }
}
