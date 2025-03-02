//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Foundation

public protocol ViewDataModelConvertible {
    associatedtype DomainType

    /// Used to convert any model to a corresponding domain model
    ///

    func toViewDataModel() -> DomainType
}
