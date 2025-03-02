//  
//  ServiceDetailsViewModel.swift
//  LayersSpa
//
//  Created by marwa on 11/08/2024.
//

import Foundation
import Networking

// MARK: ServiceDetailsViewModel

class ServiceDetailsViewModel {
    private var sectionsItems = [ServiceDetailsTableViewSectionsItem]()
    
    private var useCase: ServiceDetailsUseCase
    
    init(useCase: ServiceDetailsUseCase = ServiceDetailsUseCase()) {
        self.useCase = useCase
    }
    
    private var serviceDetailsViewModels: ServiceDetailVM? {
        didSet {
            onReloadData(serviceDetailsViewModels!)
        }
    }
    
    var state: ViewState = .empty {
        didSet {
            onUpdateLoadingStatus(state)
        }
    }
    
    var alertNetworkErrorMessage: String = "" {
        didSet {
            onShowNetworkErrorAlertClosure(alertNetworkErrorMessage)
        }
    }
    
    
    var onReloadData: ((ServiceDetailVM) -> Void) = { _ in }
    var onShowNetworkErrorAlertClosure: ((String) -> Void) = { _ in }
    var onUpdateLoadingStatus: ((ViewState) -> Void) = { _ in }
    
  
}

// MARK: ServiceDetailsViewModel

extension ServiceDetailsViewModel: ServiceDetailsViewModelInput {
    func getServiceDetails(_ serviceId: String) {
        self.state = .loading
        if(!Connectivity.isConnectedToInternet){
            alertNetworkErrorMessage = "check your network connection"
            return
        }
        
        useCase.getServiceDetails(serviceId, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.state = .loaded
                self.drawServiceDetailsPage()
                self.serviceDetailsViewModels = data
                
            case .failure(let error):
                switch error {
                case .message(let errorDesc):
                    self.state = .error
                    self.alertNetworkErrorMessage = errorDesc
                    
                }
            }
        })
    }
}

// MARK: ServiceDetailsViewModelOutput

extension ServiceDetailsViewModel: ServiceDetailsViewModelOutput {
    func getSectionItem (_ index: Int) -> ServiceDetailsTableViewSectionsItem {
        return sectionsItems[index]
    }
    
    func getSectionsNumber() -> Int {
        return sectionsItems.count
    }
    
}

// MARK: Private Handlers

private extension ServiceDetailsViewModel {
    func drawServiceDetailsPage() {
        
        let imageItem = ServiceImagesSectionlItem()
        sectionsItems.append(imageItem)
        
        let descriptionItem = ServiceDescriptionSectionlItem()
        sectionsItems.append(descriptionItem)
        
//        let reviewsItem = ServiceReviewsSectionlItem(rowCount: serviceDetailsViewModels?.reviews.count ?? 0)
//        sectionsItems.append(reviewsItem)
        
        let mightLikeItem = ServiceMightLikeSectionlItem()
        sectionsItems.append(mightLikeItem)
        
    }
    
}
