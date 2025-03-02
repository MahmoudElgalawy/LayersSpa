//
//  CheckOutRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 03/02/2025.
//

import Foundation
import Alamofire
import Networking

protocol TransactionRemoteProtocol {
    //func CreateeOrder(completion: @escaping (Result<TransactionData, Error>) -> Void)
    func SaveCartProduct(_ userId: Int, _ productsId: [String], _ itemsQty: [Int])
    func abandonedState (_ userId: String, _ orderId: Int,completion: @escaping (Bool) -> ())
    func bookingConfirmation (servicesIds: [Int?]?,reservationIds: [Int?]?,pareentReservationId: Int?,orderId: Int,completion: @escaping (Bool) -> ())
    func createReservation(
        customerId: Int,
        startDate: String,
        endDate: String,
        ecommOrderId: Int,
        branchId: String,
        serviceId: [Int],
        serviceQty: [Int],
        employeeId: [Int],
        startTime: [String],
        endTime: [String],
        completion: @escaping (Result<ReservationResponse, Error>) -> Void
    )
    var savedToCart: (Int?)->() {get set}
}


class TransactionRemote: Remote, TransactionRemoteProtocol {
    
    var savedToCart: (Int?) -> () = { _ in }
    var currentRequest: DataRequest?
    
    private let baseURL = "https://taccounting.vodoerp.com/"

    // MARK: - Save Cart Product
    func SaveCartProduct(_ userId: Int, _ productsId: [String], _ itemsQty: [Int]) {
        let url = "https://testecommerce.vodoerp.com/api/v2/abandoned_order"
        let parameters: Parameters = [
            "user_id": userId,
            "product_id": productsId,
            "item_qty": itemsQty
        ]
        
        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "lang": "en"
        ]
        
        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")
        print("📌 Parameters: \(parameters)")

        do {
            var urlRequest = try URLRequest(url: url, method: .post, headers: headers)
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseData { [weak self] response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let decodedResponse = try JSONDecoder().decode(SaveCartProducts.self, from: data)
                            self?.savedToCart(decodedResponse.data.details.first?.orderID)
                            print("✅ Success: \(decodedResponse)")
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
                        
                        if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                            print("📌 Server Response: \(jsonString)")
                        }
                    }
                }
        }catch{
            print("❌ Error creating request: \(error.localizedDescription)")
        }
    }

    // MARK: - Update Abandoned Order State
    func abandonedState(_ userId: String, _ orderId: Int, completion: @escaping (Bool) -> ()) {
        let urlString = "https://testecommerce.vodoerp.com/api/v2/abandoned_order/\(orderId)"
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 30
        request.setValue("4765066450c0bd66325.48403130", forHTTPHeaderField: "secure-business-key")
        request.setValue("en", forHTTPHeaderField: "lang")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["user_id": userId]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("❌ JSON Encoding Error: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        print("🔵 Sending request to: \(urlString)")
        print("📌 Headers: \(request.allHTTPHeaderFields ?? [:])")
        print("📌 Parameters: \(parameters)")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Request Failed: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Invalid response")
                    completion(false)
                    return
                }
                
                let statusCode = httpResponse.statusCode
                print("📌 Status Code: \(statusCode)")
                
                guard (200...299).contains(statusCode), let data = data else {
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        print("📌 Server Response: \(jsonString)")
                    }
                    completion(false)
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(AbandonedOrderResponse.self, from: data)
                    print("✅ Success: \(decodedResponse.data)")
                    completion(true)
                } catch {
                    print("⚠️ Decoding Error: \(error.localizedDescription)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("📌 Raw Response: \(jsonString)")
                    }
                    completion(false)
                }
            }
        }
        
        task.resume()
    }


    // MARK: - Create Reservation
    func createReservation(
        customerId: Int,
        startDate: String,
        endDate: String,
        ecommOrderId: Int,
        branchId: String,
        serviceId: [Int],
        serviceQty: [Int],
        employeeId: [Int],
        startTime: [String],
        endTime: [String],
        completion: @escaping (Result<ReservationResponse, Error>) -> Void
    ) {
        let url = "https://testcalendar.vodoglobal.com/api/add_new_reservation"

        let parameters: Parameters = [
            "title": "حجز جديد للعميل بوك ٦",
            "customer_id": customerId,
            "start_date": startDate,
            "end_date": endDate,
            "ecomm_order_id": ecommOrderId,
            "branch_id": branchId,
            "service_id": serviceId,
            "service_qty": serviceQty,
            "employee_id": employeeId,
            "start_time": startTime,
            "end_time": endTime
        ]

        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
            "Content-Type": "application/json",
            "user-token" : "\((Defaults.sharedInstance.userData?.token)!)"
        ]

        print("🔵 Sending request to: \(url)")
        print("📌 Headers: \(headers)")
        print("📌 Parameters: \(parameters)")

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                            print("📌 API Response: \(jsonString)")
                        }
                    do {
                        let decodedResponse = try JSONDecoder().decode(ReservationResponse.self, from: data)
                        print("✅ Success: \(decodedResponse)")
                        
                            completion(.success(decodedResponse))
                        
                    } catch let decodingError {
                        print("⚠️ Decoding Error: \(decodingError)")
                        completion(.failure(decodingError))
                    }
                    
                case .failure(let error):
                    let statusCode = response.response?.statusCode ?? 0
                    print("❌ Request Failed with Status Code: \(statusCode)")
                    print("📌 Error: \(error.localizedDescription)")
                    
                    if let data = response.data, let jsonString = String(data: data, encoding: .utf8) {
                        print("📌 Server Response: \(jsonString)")
                    }
                    
                    completion(.failure(error))
                }
            }
    }
    
    
    func bookingConfirmation (servicesIds: [Int?]?,reservationIds: [Int?]?,pareentReservationId: Int?,orderId: Int,completion: @escaping (Bool) -> ()){
        let url = "https://testecommerce.vodoerp.com/api/v2/update_reservation_id/\(orderId)"
        let headers: HTTPHeaders = [
            "secure-business-key": "4765066450c0bd66325.48403130",
        ]
        let parameters: Parameters = [
            "service_id": servicesIds ?? [],
            "reservation_id": reservationIds ?? [],
            "parent_reservation_id": pareentReservationId ?? 0
        ]
        
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(confirmResponse.self, from: data)
                        print("✅ Success: \(decodedResponse.message)")
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

