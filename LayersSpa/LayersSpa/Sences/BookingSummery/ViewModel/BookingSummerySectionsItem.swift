//
//  BookingSummerySectionsItem.swift
//  LayersSpa
//
//  Created by marwa on 01/08/2024.
//

import Foundation

enum BookingSummerySectionsType {
    case BookingDetails
    case CartItems
    case Footer
    
}

protocol BookingSummerySectionsItem {
    var type: BookingSummerySectionsType { get }
    var rowCount: Int { get }
    var isExpanded: Bool { get set }
}

class BookingSummeryDetailsSectionsItem: BookingSummerySectionsItem {
    
    
    private let _rowCount: Int
    
    var isExpanded: Bool
    
    init(rowCount: Int = 1, isExpanded: Bool = false) {
        self._rowCount = rowCount
        self.isExpanded = isExpanded
    }
    
    var type: BookingSummerySectionsType {
        return .BookingDetails
    }
    
    var rowCount: Int {
        return _rowCount
    }
}

class BookingSummeryCartItemsSectionsItem: BookingSummerySectionsItem {
    
    
    private let _rowCount: Int
    
    var isExpanded: Bool
    
    init(rowCount: Int = 1, isExpanded: Bool = false) {
        self._rowCount = rowCount
        self.isExpanded = isExpanded
    }
    
    var type: BookingSummerySectionsType {
        return .CartItems
    }
    
    var rowCount: Int {
        return _rowCount
    }
}

class BookingSummeryFooterSectionsItem: BookingSummerySectionsItem {
    
    private let _rowCount: Int
    
    var isExpanded: Bool
    
    init(rowCount: Int = 1, isExpanded: Bool = true) {
        self._rowCount = rowCount
        self.isExpanded = isExpanded
    }
    
    var type: BookingSummerySectionsType {
        return .Footer
    }
    
    var rowCount: Int {
        return _rowCount
    }
}


