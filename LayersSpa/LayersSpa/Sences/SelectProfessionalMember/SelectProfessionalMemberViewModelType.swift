//  
//  SelectProfessionalMemberViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import Foundation

/// SelectProfessionalMember Input & Output
///
typealias SelectProfessionalMemberViewModelType = SelectProfessionalMemberViewModelInput & SelectProfessionalMemberViewModelOutput

/// SelectProfessionalMember ViewModel Input
///
protocol SelectProfessionalMemberViewModelInput {
    var members: [Employee] {get set}
}

/// SelectProfessionalMember ViewModel Output
///
protocol SelectProfessionalMemberViewModelOutput {}
