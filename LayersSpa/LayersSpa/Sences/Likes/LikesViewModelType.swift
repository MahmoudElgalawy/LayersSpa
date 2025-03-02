//  
//  LikesViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import Foundation

/// Likes Input & Output
///
typealias LikesViewModelType = LikesViewModelInput & LikesViewModelOutput

/// Likes ViewModel Input
///
protocol LikesViewModelInput {
    func getLikeProductsList(_ type: CoreDataProductType)
    var onReloadData: (([ProductVM]) -> Void) {get set}
    var servicesViewModels: [ProductVM] {get set}
    
}

/// Likes ViewModel Output
///
protocol LikesViewModelOutput {
    func getServicesNum() -> Int
    func getProductssNum() -> Int
    func getProduct(_ index: Int) -> ProductVM
    func getService(_ index: Int) -> ProductVM 
}
