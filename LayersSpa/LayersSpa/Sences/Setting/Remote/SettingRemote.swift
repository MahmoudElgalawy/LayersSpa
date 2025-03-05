//
//  SettingRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 21/02/2025.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///
 protocol SettingRemoteProtocol {
     func LogOut(completion: @escaping (Result<Login, Error>) -> Void)
}

/// Login: Remote Endpoints
///
 class SettingRemote: Remote, SettingRemoteProtocol {

     func LogOut( completion: @escaping (Result<Login, Error>) -> Void) {
        let path = "api/customers/deactive_customer/\((Defaults.sharedInstance.userData?.userId)!)"

        
        let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path,header: [
            "secure-business-key": Settings.secureBusinessKey,
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)",
                 "Platform": "ios",
                 "user-token": " \((Defaults.sharedInstance.userData?.token)!)"
        ])
        enqueue(request, completion: completion)
    }
}
