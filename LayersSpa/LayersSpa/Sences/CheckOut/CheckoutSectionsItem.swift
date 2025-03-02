//
//  CheckoutSectionsItem.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import Foundation

enum CheckoutSectionsType {
   // case DiscoundCode
    //case OrderSummery
    case Payment
    case Footer
}

protocol CheckoutSectionsItem {
    var type: CheckoutSectionsType { get }
    var rowCount: Int { get }
    var isExpanded: Bool { get set }
}

//class CheckoutDiscountCodeSectionsItem: CheckoutSectionsItem {
//
//    private let _rowCount: Int
//    
//    var isExpanded: Bool
//    
//    init(rowCount: Int = 1, isExpanded: Bool = false) {
//        self._rowCount = rowCount
//        self.isExpanded = isExpanded
//    }
//    
//    var type: CheckoutSectionsType {
//        return .DiscoundCode
//    }
//    
//    var rowCount: Int {
//        return _rowCount
//    }
//}
//
//class CheckoutOrderSummerySectionsItem: CheckoutSectionsItem {
//
//    private let _rowCount: Int
//    
//    var isExpanded: Bool
//    
//    init(rowCount: Int = 1, isExpanded: Bool = false) {
//        self._rowCount = rowCount
//        self.isExpanded = isExpanded
//    }
//    
//    var type: CheckoutSectionsType {
//        return .OrderSummery
//    }
//    
//    var rowCount: Int {
//        return _rowCount
//    }
//}

class CheckoutPaymentSectionsItem: CheckoutSectionsItem {

    private let _rowCount: Int
    
    var isExpanded: Bool
    
    init(rowCount: Int = 1, isExpanded: Bool = false) {
        self._rowCount = rowCount
        self.isExpanded = isExpanded
    }
    
    var type: CheckoutSectionsType {
        return .Payment
    }
    
    var rowCount: Int {
        return _rowCount
    }
}

class CheckoutFooterSectionsItem: CheckoutSectionsItem {

    private let _rowCount: Int
    
    var isExpanded: Bool
    
    init(rowCount: Int = 1, isExpanded: Bool = true) {
        self._rowCount = rowCount
        self.isExpanded = isExpanded
    }
    
    var type: CheckoutSectionsType {
        return .Footer
    }
    
    var rowCount: Int {
        return _rowCount
    }
}
