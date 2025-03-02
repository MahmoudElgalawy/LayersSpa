//  
//  HomeViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation

/// Home Input & Output
///
typealias HomeViewModelType = HomeViewModelInput & HomeViewModelOutput

/// Home ViewModel Input
///
protocol HomeViewModelInput {
    func getHomeData(_ branchId: String)
    func getBranches(completion: @escaping ([BrancheVM]) -> Void) 
}

/// Home ViewModel Output
///
protocol HomeViewModelOutput {
    
    func getSectionItem (_ index: Int) -> HomeTableViewSectionsItem
    func getSectionsNumber() -> Int
    func getServices() -> [ProductVM]
    func getProducts() -> [ProductVM]
    func getCategories() -> [CategoriesVM]
    func getBrancesList() -> [BrancheVM]
    
    var onReloadData: ((HomeVM) -> Void) { get set }
    var onShowNetworkErrorAlert: (String) -> Void { get set }
    var onUpdateLoadingStatus: (ViewState) -> Void { get set }
//    var state: ViewState { get set }
//    var branchesReload: (() -> ()) { get set }
    var homeData: HomeVM? {get set}
}
