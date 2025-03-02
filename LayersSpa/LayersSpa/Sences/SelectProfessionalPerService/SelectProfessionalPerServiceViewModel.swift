//  
//  SelectProfessionalPerServiceViewModel.swift
//  LayersSpa
//
//  Created by 2B on 30/07/2024.
//

import Foundation

// MARK: SelectProfessionalPerServiceViewModel

class SelectProfessionalPerServiceViewModel {
    var services: [ProductVM] = []
    var members: [Employee] = []
}

// MARK: SelectProfessionalPerServiceViewModel

extension SelectProfessionalPerServiceViewModel: SelectProfessionalPerServiceViewModelInput {}

// MARK: SelectProfessionalPerServiceViewModelOutput

extension SelectProfessionalPerServiceViewModel: SelectProfessionalPerServiceViewModelOutput {}

// MARK: Private Handlers

private extension SelectProfessionalPerServiceViewModel {}
