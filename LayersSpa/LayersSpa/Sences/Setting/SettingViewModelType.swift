//  
//  SettingViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import Foundation

/// Setting Input & Output
///
typealias SettingViewModelType = SettingViewModelInput & SettingViewModelOutput

/// Setting ViewModel Input
///
protocol SettingViewModelInput {}

/// Setting ViewModel Output
///
protocol SettingViewModelOutput {
    func getSectionItem (_ index: Int) -> SettingTableViewSectionsItem
    func getSectionsNumber() -> Int
    func getPasswordRowInfo() -> settingVM
//    func getAccountRowInfo() -> settingVM
//    func getNotificationRowInfo(_ index: Int) -> settingVM
    func getLanguageRowInfo(_ index: Int) -> settingVM
    func logOut(completion: @escaping (Bool)->())
}
