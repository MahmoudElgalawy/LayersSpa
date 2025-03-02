//  
//  SelectProfessionalOptionsViewModel.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import Foundation
import Networking

// MARK: SelectProfessionalOptionsViewModel

class SelectProfessionalOptionsViewModel {
    private let remote: AvailableEmployeeTimesRemoteProtocol
    private static var networking: Network = AlamofireNetwork()
       var availableEmployees: [Employee] = []
       var employeeIDs:[Int] = []
       var isLoading: Bool = false
       var errorMessage: String?
       
       var onDataFetched: (() -> Void)?
       var onError: ((String) -> Void)?
       
    init(remote: AvailableEmployeeTimesRemoteProtocol = AvailableEmployeeTimesRemote(network: networking)) {
           self.remote = remote
       }
       
       func fetchAvailableEmployees(date: String, branchID: String, employeeIDs: [Int]) {
           isLoading = true
           errorMessage = nil
           
           remote.fetchAvailableEmployeeTimes(date: date, branchID: branchID, employeeIDs: employeeIDs) { [weak self] result in
               guard let self = self else { return }
               
               DispatchQueue.main.async {
                   self.isLoading = false
                   
                   switch result {
                   case .success(let response):
                      
                       print( "availableEmployees :::::::::::::::::::::::::::::---->\(self.availableEmployees)")
                       DispatchQueue.main.async {
                           self.availableEmployees = response.data.data
                           self.onDataFetched?()
                       }
                   case .failure(let error):
                       self.errorMessage = "Failed to fetch employees: \(error.localizedDescription)"
                       self.onError?(self.errorMessage!)
                   }
               }
           }
       }
}

// MARK: SelectProfessionalOptionsViewModel

extension SelectProfessionalOptionsViewModel: SelectProfessionalOptionsViewModelInput {}

// MARK: SelectProfessionalOptionsViewModelOutput

extension SelectProfessionalOptionsViewModel: SelectProfessionalOptionsViewModelOutput {}

// MARK: Private Handlers

private extension SelectProfessionalOptionsViewModel {}
