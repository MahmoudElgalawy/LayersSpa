//
//  SettingTableViewSectionsType.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import Foundation

enum SettingTableViewSectionsType: String {
    case Delete = "Account"
    case appLanguage = "Language"
//    case notifications = "Notification"
//    case account = "Account"
}

protocol SettingTableViewSectionsItem {
    var type: SettingTableViewSectionsType { get }
    var rowCount: Int { get }
}

class passwordSectionlItem: SettingTableViewSectionsItem {
    var type: SettingTableViewSectionsType {
        return .Delete
    }

    var rowCount: Int {
        return 1
    }
}

class languageSectionlItem: SettingTableViewSectionsItem {
    var type: SettingTableViewSectionsType {
        return .appLanguage
    }

    var rowCount: Int {
        return 2
    }
}

//class notificationsSectionlItem: SettingTableViewSectionsItem {
////    var type: SettingTableViewSectionsType {
////        return .notifications
////    }
//
//    var rowCount: Int {
//        return 2
//    }
//}
//
//class accountSectionlItem: SettingTableViewSectionsItem {
////    var type: SettingTableViewSectionsType {
////        return .account
////    }
//
//    var rowCount: Int {
//        return 1
//    }
//}
