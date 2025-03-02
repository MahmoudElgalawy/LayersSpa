//  
//  SelectProfessionalPerServiceViewModelType.swift
//  LayersSpa
//
//  Created by 2B on 30/07/2024.
//

import Foundation

/// SelectProfessionalPerService Input & Output
///
typealias SelectProfessionalPerServiceViewModelType = SelectProfessionalPerServiceViewModelInput & SelectProfessionalPerServiceViewModelOutput

/// SelectProfessionalPerService ViewModel Input
///
protocol SelectProfessionalPerServiceViewModelInput {
    var services: [ProductVM] {get set}
    var members: [Employee] {get set}
}

/// SelectProfessionalPerService ViewModel Output
///
protocol SelectProfessionalPerServiceViewModelOutput {}
