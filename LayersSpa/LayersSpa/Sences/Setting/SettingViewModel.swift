//  
//  SettingViewModel.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import Foundation
import Networking

// MARK: SettingViewModel

class SettingViewModel {
    private var sectionsItems = [SettingTableViewSectionsItem]()
    var passwordInfo = settingVM(type: .Delete, title: String(localized: "deleteAccount"), icon: .deleteIcone)
    var language: [settingVM] = [
        settingVM(type: .appLanguage, title: "العربية", icon: .arabic),
        settingVM(type: .appLanguage, title: "English", icon: .english)
    ]
    let remote: SettingRemoteProtocol =  SettingRemote(network: AlamofireNetwork())
//    var notification: [settingVM] = [
//        settingVM(type: .notifications, title: "App Notifications", icon: .notification1),
//        settingVM(type: .notifications, title: "Email Notifications", icon: .email1)
//    ]
//    var account = settingVM(type: .account, title: "Delete Account", icon: .deleteIcone)
    
    init() {
        drawHomePage()
    }
}

// MARK: SettingViewModel

extension SettingViewModel: SettingViewModelInput {}

// MARK: SettingViewModelOutput

extension SettingViewModel: SettingViewModelOutput {
    func getSectionItem (_ index: Int) -> SettingTableViewSectionsItem {
        return sectionsItems[index]
    }
    
    func getSectionsNumber() -> Int {
        return sectionsItems.count
    }
    
    func getPasswordRowInfo() -> settingVM {
        return passwordInfo
    }
//    func getAccountRowInfo() -> settingVM {
//        return account
//    }
//    func getNotificationRowInfo(_ index: Int) -> settingVM{
//        return notification[index]
//    }
    func getLanguageRowInfo(_ index: Int) -> settingVM {
        return language[index]
    }
    
    func logOut(completion: @escaping (Bool)->()){
        remote.LogOut { result in
            switch result{
            case .success(let data):
                completion(data.status)
            case .failure(let error):
                completion(false)
            }
        }
    }
}

// MARK: Private Handlers

private extension SettingViewModel {
    func drawHomePage() {
        
        let passwordItem = passwordSectionlItem()
        sectionsItems.append(passwordItem)
        
        let languageItem = languageSectionlItem()
        sectionsItems.append(languageItem)
        
//        let notification = notificationsSectionlItem()
//        sectionsItems.append(notification)
//        
//        let account = accountSectionlItem()
//        sectionsItems.append(account)
//        
    }
    
}
