//
//  File.swift
//  
//
//  Created by marwa on 13/08/2024.
//

import Foundation

public enum Settings {

    /// Base API URL
    ///
    public static let registrationsApiBaseURL = "https://taccounting.vodoerp.com/"
    
    public static let ecommerceApiBaseURL = "https://testecommerce.vodoerp.com/"
    
    public static let accountApiBaseURL = "https://testaccounts.vodoerp.com/"
    
    
    /// headers
    ///
    public static let secureBusinessKey = "4765066450c0bd66325.48403130"
    
    public static let platform = "android"
    
    public static let platformKey = "387666a26a0ad869c9.00802837"
}



//public func Login(_ phoneNumber: String, _ password: String, completion: @escaping (Result<Login, Error>) -> Void) {
//    let path = "api/customers/login_business_customer"
//    let parameters: Parameters = ["phone": phoneNumber,
//                                  "password": password]
//    
//    let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters, header: [
//        "Authorization": Settings.secureBusinessKey,
//        "Platform": Settings.platform
//    ])
//    enqueue(request, completion: completion)
//}
