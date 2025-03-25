//
//  MyAccountRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 02/02/2025.
//

import Foundation
import Alamofire

 protocol MyAccountRemoteProtocol {
    func fetchUserProfile(completion: @escaping (Result<APIResponse, Error>) -> Void)
    func updateUserProfile(token: String, firstName: String, email: String, phone: String, image: Data?, completion: @escaping (Result<String, Error>) -> Void)
}

class MyAccountRemote: MyAccountRemoteProtocol {

    let baseURL = "https://taccounting.vodoerp.com"
    
    func fetchUserProfile(completion: @escaping (Result<APIResponse, Error>) -> Void) {
        
        let path = "/api/show_customer/\((Defaults.sharedInstance.userData?.userId) ?? 0)"
        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "platform": "android",
            "platform-key": "387666a26a0ad869c9.00802837",
            "Accept-Language":"\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)",
            "apikey": "efe2db322a53",
            "user-token": "\((Defaults.sharedInstance.userData?.token) ?? "0")"
        ]

        let url = "\(baseURL)\(path)"

        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: APIResponse.self) { response in
                switch response.result {
                case .success(let userProfile):
                    print("✅ Success: \(userProfile)")
                    completion(.success(userProfile))
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
    
    func updateUserProfile(token: String, firstName: String, email: String, phone: String, image: Data?, completion: @escaping (Result<String, Error>) -> Void) {

        guard let userId = Defaults.sharedInstance.userData?.userId else {
            completion(.failure(NSError(domain: "UserID Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
            return
        }

        let url = "\(baseURL)/api/edit_customer/\(userId)"

        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "platform": "android",
            "platform-key": "387666a26a0ad869c9.00802837",
            "Accept-Language": (UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String) ?? "en",
            "apikey": "efe2db322a53",
            "user-token": token
        ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(firstName.utf8), withName: "name")
            multipartFormData.append(Data(email.utf8), withName: "email")
            multipartFormData.append(Data(phone.utf8), withName: "phone")

            if let imageData = image {
                multipartFormData.append(imageData, withName: "image", fileName: "\(email)\(Date().timeIntervalSince1970).jpg", mimeType: "image/jpeg")
            }

        }, to: url, method: .post, headers: headers)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let json):
                print("✅ Profile Updated: \(json)")
                completion(.success("Profile updated successfully"))
            case .failure(let error):
                print("❌ Update Failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


}

