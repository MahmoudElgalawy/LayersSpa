//
//  PaymentRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 10/02/2025.
//

import Foundation
import Alamofire
import Networking

protocol PaymentRemoteProtocol {
    func bookingConfirmation (name: String,visaNumber: String,month: String,year: String,cvc: String, total:String, customerId: String,ecommOrderId: String,completion: @escaping (Bool) -> ())
}


class PaymentRemote: Remote, PaymentRemoteProtocol {
    
    
    func bookingConfirmation (name: String,visaNumber: String,month: String,year: String,cvc: String, total:String, customerId: String,ecommOrderId: String,completion: @escaping (Bool) -> ()){
        let url = "https://taccounting.vodoerp.com/api/advanced_payment/moyasar_payment"
        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
        ]
        let parameters: Parameters = [
            "name": name ,
            "number": visaNumber ,
            "month": month,
            "year":year,
            "cvc" :cvc,
            "total":total,
            "customer_id":customerId,
            "ecomm_order_id":ecommOrderId
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(PaymentResponse.self, from: data)
                        print("✅ Success: \(decodedResponse.message) +!!!!!!!!!!!!!!!!!!!")
                            completion(true)
                    } catch let decodingError {
                        print("⚠️ Decoding Error: \(decodingError)")
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📌 Raw Response: \(jsonString)")
                        }
                        completion(false)
                    }
                    
                case .failure(let error):
                    let statusCode = response.response?.statusCode ?? 0
                    print("❌ Request Failed with Status Code: \(statusCode)")
                    print("📌 Error: \(error.localizedDescription)")
                    completion(false)
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("📌 Server Response: \(jsonString)")
                    }
                }
            }
    }
    
}
