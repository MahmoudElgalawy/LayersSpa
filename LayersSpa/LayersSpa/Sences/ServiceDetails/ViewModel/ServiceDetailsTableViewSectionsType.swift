//
//  ServiceDetailsSectionType.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.


import Foundation

enum ServiceDetailsTableViewSectionsType {
    case serviceImage
    case serviceDescription
    //case serviceReviews
    case serviceMightLike
}

protocol ServiceDetailsTableViewSectionsItem {
    var type: ServiceDetailsTableViewSectionsType { get }
    var rowCount: Int { get }
}

class ServiceImagesSectionlItem: ServiceDetailsTableViewSectionsItem {
    
    private let _rowCount: Int
    
    init(rowCount: Int = 1) {
        self._rowCount = rowCount
    }
    
    var type: ServiceDetailsTableViewSectionsType {
        return .serviceImage
    }

    var rowCount: Int {
        return _rowCount
    }
}

class ServiceDescriptionSectionlItem: ServiceDetailsTableViewSectionsItem {
    
    private let _rowCount: Int
    
    init(rowCount: Int = 1) {
        self._rowCount = rowCount
    }
    
    var type: ServiceDetailsTableViewSectionsType {
        return .serviceDescription
    }

    var rowCount: Int {
        return _rowCount
    }
}

//class ServiceReviewsSectionlItem: ServiceDetailsTableViewSectionsItem {
//    
//    private let _rowCount: Int
//    
//    init(rowCount: Int = 1) {
//        self._rowCount = rowCount
//    }
//    
//    var type: ServiceDetailsTableViewSectionsType {
//        return .serviceReviews
//    }
//
//    var rowCount: Int {
//        return _rowCount
//    }
//}

class ServiceMightLikeSectionlItem: ServiceDetailsTableViewSectionsItem {
    
    private let _rowCount: Int
    
    init(rowCount: Int = 1) {
        self._rowCount = rowCount
    }
    
    var type: ServiceDetailsTableViewSectionsType {
        return .serviceMightLike
    }

    var rowCount: Int {
        return _rowCount
    }
}
