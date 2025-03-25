//
//  CalenderRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 09/02/2025.
//

import Foundation
import Alamofire
import Networking

protocol CalendersRemoteProtocol {
    func getAppointment(userId: Int, type: String, filterDate: String, page: Int, completion: @escaping (Result<CalenderResponse, Error>) -> Void)
    func getAppointmentDetails(ordersID:String, completion: @escaping (Result<OrdersResponse, Error>) -> Void)
}

class CalendersRemote: Remote, CalendersRemoteProtocol {
    
    
    private let baseURL = "https://taccounting.vodoerp.com/"
    
    // MARK: - Save Cart Product
    func getAppointment(userId: Int, type: String, filterDate: String, page: Int, completion: @escaping (Result<CalenderResponse, Error>) -> Void) {
        
        let url = "https://testcalendar.vodoglobal.com/api/user-reservations/\(userId)"
        
        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]
        
        let parameters: Parameters = [
            "type": type,
            "filter_date": filterDate,
            "page": page,
            "per_page": 10 
        ]
        
        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")
        print("📌 Parameters: \(parameters)")
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(CalenderResponse.self, from: data)
                        print("✅ Success: \(decodedResponse)")
                        completion(.success(decodedResponse))
                    } catch let decodingError {
                        print("⚠️ Decoding Error: \(decodingError)")
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📌 Raw Response: \(jsonString)")
                        }
                    }
                    
                case .failure(let error):
                    let statusCode = response.response?.statusCode ?? 0
                    print("❌ Request Failed with Status Code: \(statusCode)")
                    print("📌 Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("📌 Server Response: \(jsonString)")
                    }
                }
            }
    }

    
    func getAppointmentDetails(ordersID:String, completion: @escaping (Result<OrdersResponse, Error>) -> Void){
   
        let url = "https://testecommerce.vodoerp.com/api/v2/user_orders_list_v2/\((Defaults.sharedInstance.userData?.userId) ?? 0)"
        
        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"
        ]
        let parameters: Parameters = [
            "orders_id": ordersID
        ]
        
        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")
        
            AF.request(url, method: .get, parameters: parameters, encoding:URLEncoding.default, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let decodedResponse = try JSONDecoder().decode(OrdersResponse.self, from: data)
                            print("✅ Success: \(decodedResponse)")
                            completion(.success(decodedResponse))
                        } catch let decodingError {
                            print("⚠️ Decoding Error: \(decodingError)")
                            if let jsonString = String(data: data, encoding: .utf8) {
                                print("📌 Raw Response: \(jsonString)")
                            }
                        }
                        
                    case .failure(let error):
                        let statusCode = response.response?.statusCode ?? 0
                        print("❌ Request Failed with Status Code: \(statusCode)")
                        print("📌 Error: \(error.localizedDescription)")
                        completion(.failure(error))
                        if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                            print("📌 Server Response: \(jsonString)")
                        }
                    }
                }
        
    }
    
    }
