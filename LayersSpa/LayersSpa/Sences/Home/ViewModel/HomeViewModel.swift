//
//  HomeViewModel.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation
import Networking

// MARK: HomeViewModel

class HomeViewModel {
    
    // MARK: - Properties
    private var useCase: HomeUseCase
    private var sectionsItems = [HomeTableViewSectionsItem]()
    private var branchesList: [BrancheVM] = [BrancheVM(id: "", name: String(localized: "allBranches"), address: "")]
    var homeData: HomeVM?
    
    // Callbacks
    var onReloadData: ((HomeVM) -> Void) = { _ in }
    var onShowNetworkErrorAlert: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
    
    // MARK: - Initialization
    init(useCase: HomeUseCase = HomeUseCase()) {
        self.useCase = useCase
    }
    
    // MARK: - Data Fetching
    func getHomeData(_ branchId: String) {
        updateState(.loading)
        
        guard Connectivity.isConnectedToInternet else {
            onShowNetworkErrorAlert("Check your network connection")
            return
        }
        
        useCase.getHomeData(branchId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.homeData = data
                self.drawHomePage(data)
                self.updateState(.loaded)
                self.onReloadData(data)
                
                print("Service BranchID ==============================::::::::::::::::::::::::::::: \(data.services?.first?.branchesId)")
            case .failure(let error):
                self.updateState(.error)
                self.onShowNetworkErrorAlert(error.localizedDescription)
            }
        }
    }
    
    func getBranches(completion: @escaping ([BrancheVM]) -> Void) {
        updateState(.loading)
        
        guard Connectivity.isConnectedToInternet else {
            onShowNetworkErrorAlert("Check your network connection")
            return
        }
        
        useCase.getBranches { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if self.branchesList.count == 1 { // Only "All Branches" exists
                    self.branchesList.append(contentsOf: data.branches)
                }
                self.updateState(.loaded)
                completion(self.branchesList)
                
                // Cache branches
                if let encodedData = try? JSONEncoder().encode(self.branchesList) {
                    UserDefaults.standard.set(encodedData, forKey: "Branches")
                }
            case .failure(let error):
                self.updateState(.error)
                self.onShowNetworkErrorAlert(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Methods
    private func updateState(_ state: ViewState) {
        DispatchQueue.main.async {
            self.onUpdateLoadingStatus(state)
        }
    }
    
    private func drawHomePage(_ pageData: HomeVM) {
        sectionsItems.removeAll()
        
        if pageData.categories?.isEmpty == false {
            sectionsItems.append(HomeCategorySectionlItem())
        }
        
        if pageData.products?.isEmpty == false {
            sectionsItems.append(HomeShopSectionlItem())
        }
        
        if pageData.services?.isEmpty == false {
            sectionsItems.append(HomeServiceSectionlItem())
        }
    }
}
    

// MARK: HomeViewModel

extension HomeViewModel: HomeViewModelInput {
}

// MARK: HomeViewModelOutput

extension HomeViewModel: HomeViewModelOutput {
    
    
    
    func getSectionItem (_ index: Int) -> HomeTableViewSectionsItem {
        return sectionsItems[index]
    }
    
    func getSectionsNumber() -> Int {
        return sectionsItems.count
    }
    
    func getServices() -> [ProductVM] {
        return homeData?.services ?? []
    }
    
    func getProducts() -> [ProductVM] {
        return homeData?.products ?? []
    }
    
    func getCategories() -> [CategoriesVM] {
//        if let cats = homeData?.categories{
//            for cat in  cats {
//                titles.append(cat.title)
//            }
//        }
        return homeData?.categories ?? []
    }
    
    func getBrancesList() -> [BrancheVM] {
        return branchesList
    }
    
}

// MARK: Private Handlers

private extension HomeViewModel {
 
    
}
