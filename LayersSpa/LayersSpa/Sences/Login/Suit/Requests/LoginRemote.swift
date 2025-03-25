//
//  LoginRemote.swift
//  LayersSpa
//
//  Created by marwa on 13/08/2024.
//

import Foundation
import Alamofire
import Networking
import FirebaseMessaging

/// Protocol for `LoginRemote` mainly used for mocking.
///
public protocol LoginRemoteProtocol {
    func Login(_ phoneNumber: String, _ password: String, completion: @escaping (Result<Login, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class LoginRemote: Remote, LoginRemoteProtocol {

    public func Login(_ phoneNumber: String, _ password: String, completion: @escaping (Result<Login, Error>) -> Void) {
        let path = "api/customers/login_business_customer?phone=\(phoneNumber)&password=\(password)"
        guard let token = Messaging.messaging().fcmToken else{return}
        print("Firebase Token: \(token)")
        let parameters: Parameters = ["phone": phoneNumber,
                                      "password": password,"kiosk_token":token]
        
        let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters,header: [
            "secure-business-key": Settings.secureBusinessKey,
            "apiconnection": "appmobile",
            "apikey": "5f28583f26a1a",
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)",
            "Platform": "ios",
            "Platform-key": Settings.platformKey,
        ])
        print("login request: \(request)")
        enqueue(request, completion: completion)
    }
}


//01010907051
//Mahmoud@99
//\(phoneNumber)
//\(password)
