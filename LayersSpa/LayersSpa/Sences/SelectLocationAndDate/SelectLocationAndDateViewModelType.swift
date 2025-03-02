//  
//  SelectLocationAndDateViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import Foundation

/// SelectLocationAndDate Input & Output
///
typealias SelectLocationAndDateViewModelType = SelectLocationAndDateViewModelInput & SelectLocationAndDateViewModelOutput

/// SelectLocationAndDate ViewModel Input
///
protocol SelectLocationAndDateViewModelInput {
    var employeesID: [Int] {get set}
    var errorAlert: ()->() {get set}
}

/// SelectLocationAndDate ViewModel Output
///
protocol SelectLocationAndDateViewModelOutput {
    func fetchEmployeeSkills(skillIDs: [String])
   
   // var locations : [String] {get set}
}
