//
//  ResetPasswordRemote.swift
//  LayersSpa
//
//  Created by Marwa on 26/08/2024.
//

import Foundation
import Alamofire
import Networking

/// Protocol for `LoginRemote` mainly used for mocking.
///
public protocol ResetPasswordRemoteProtocol {
    func resetPassword(_ email: String, completion: @escaping (Result<ResetPassword, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class ResetPasswordRemote: Remote, ResetPasswordRemoteProtocol {

    public func resetPassword(_ email: String, completion: @escaping (Result<ResetPassword, Error>) -> Void) {
        let path = "api/business_users/reset_password"
        let parameters: Parameters = ["phone": email]
        let headers: HTTPHeaders = [
            "secure-business-key": Settings.secureBusinessKey,
            "platform": Settings.platform,
            "platform-key": Settings.platformKey,
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)",
            "apikey": "efe2db322a53"
        ]
        
        let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters, header: headers)
        enqueue(request, completion: completion)
    }
}



