//
//  HomeTableViewSectionsType.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import Foundation

enum HomeTableViewSectionsType {
    case categories
    case layersShop
    case Services
}

protocol HomeTableViewSectionsItem {
    var type: HomeTableViewSectionsType { get }
    var rowCount: Int { get }
}

//class HomeBannersSectionlItem: HomeTableViewSectionsItem {
//    
//    private let _rowCount: Int
//    
//    init(rowCount: Int = 1) {
//        self._rowCount = rowCount
//    }
//    
//    var type: HomeTableViewSectionsType {
//        return .banners
//    }
//
//    var rowCount: Int {
//        return _rowCount
//    }
//}


class HomeCategorySectionlItem: HomeTableViewSectionsItem {
    
    private let _rowCount: Int
    
    init(rowCount: Int = 1) {
        self._rowCount = rowCount
    }
    
    var type: HomeTableViewSectionsType {
        return .categories
    }

    var rowCount: Int {
        return _rowCount
    }
}

class HomeShopSectionlItem: HomeTableViewSectionsItem {
    
    private let _rowCount: Int
    
    init(rowCount: Int = 1) {
        self._rowCount = rowCount
    }
    
    var type: HomeTableViewSectionsType {
        return .layersShop
    }

    var rowCount: Int {
        return _rowCount
    }
}

class HomeServiceSectionlItem: HomeTableViewSectionsItem {
    
    private let _rowCount: Int
    
    init(rowCount: Int = 1) {
        self._rowCount = rowCount
    }
    
    var type: HomeTableViewSectionsType {
        return .Services
    }

    var rowCount: Int {
        return _rowCount
    }
}


