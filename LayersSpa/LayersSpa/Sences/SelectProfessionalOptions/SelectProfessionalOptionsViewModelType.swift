//  
//  SelectProfessionalOptionsViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import Foundation

/// SelectProfessionalOptions Input & Output
///
typealias SelectProfessionalOptionsViewModelType = SelectProfessionalOptionsViewModelInput & SelectProfessionalOptionsViewModelOutput

/// SelectProfessionalOptions ViewModel Input
///
protocol SelectProfessionalOptionsViewModelInput {
    var isLoading: Bool {get set}
    var errorMessage: String?{get set}
    var availableEmployees: [Employee]{get set}
    var employeeIDs:[Int] {get set}
    var onDataFetched: (() -> Void)?{get set}
    var onError: ((String) -> Void)?{get set}
}

/// SelectProfessionalOptions ViewModel Output
///
protocol SelectProfessionalOptionsViewModelOutput {
    func fetchAvailableEmployees(date: String, branchID: String, employeeIDs: [Int])
}
