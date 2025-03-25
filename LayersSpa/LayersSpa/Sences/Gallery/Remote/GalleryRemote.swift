//
//  GalleryRemote.swift
//  LayersSpa
//
//  Created by Mahmoud Ahmed Hefny on 22/03/2025.
//

import Foundation
import Alamofire
import FirebaseMessaging

protocol GalleryRemoteProtocol {
    func fetchPhotos(completion: @escaping (Result<GalleryModel, Error>) -> Void)
}

class GalleryRemote: GalleryRemoteProtocol {
    let baseURL = "https://taccounting.vodoerp.com"
    let token = Messaging.messaging().fcmToken
   // https://taccounting.vodoerp.com/api/show_kiosk_images
    func fetchPhotos(completion: @escaping (Result<GalleryModel, Error>) -> Void) {
        let path = "/api/show_kiosk_images"
        let headers: HTTPHeaders = [
            "secure-business-key":"4765066450c0bd66325.48403130",
            "apikey": "efe2db322a53",
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)",
            "kiosk-token" : token ?? ""
        ]
        
        let url = "\(baseURL)\(path)"
        
        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: GalleryModel.self) { response in
                switch response.result {
                case .success(let customerBalance):
                    print("✅ Success: \(customerBalance)")
                    completion(.success(customerBalance))
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}
