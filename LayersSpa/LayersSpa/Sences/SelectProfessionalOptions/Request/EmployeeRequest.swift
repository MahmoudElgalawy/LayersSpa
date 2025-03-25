//
//  EmployeeRequest.swift
//  LayersSpa
//
//  Created by Mahmoud on 30/01/2025.
//

import Foundation
import Alamofire
import Networking


protocol AvailableEmployeeTimesRemoteProtocol {
    func fetchAvailableEmployeeTimes(date: String, branchID: String, employeeIDs: [Int], completion: @escaping (Result<EmployeeResponse, Error>) -> Void)
}

class AvailableEmployeeTimesRemote: Remote, AvailableEmployeeTimesRemoteProtocol {
    
    private let baseURL = "https://testcalendar.vodoglobal.com"
    private let path = "/api/v2/get-available-employee-times"
    
    func fetchAvailableEmployeeTimes(date: String, branchID: String, employeeIDs: [Int], completion: @escaping (Result<EmployeeResponse, Error>) -> Void) {
            let url = "\(baseURL)\(path)"
            
            // إعداد المعاملات
              let parameters: [String: Any] = [
                   "date": date,
                   "branch_id": branchID,
                   "employee_ids": employeeIDs
               ]
            
            let headers: HTTPHeaders = [
                "secure-business-key": "4765066450c0bd66325.48403130",
                "Accept": "application/json",
                "Accept-Language": "en"
            ]
            
            print("🔵 Sending request to: \(url)")
            print("📌 Parameters: \(parameters)")
            print("📌 Headers: \(headers)")
            
            // استخدام Alamofire لإرسال الطلب
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .validate()
                .responseDecodable(of: EmployeeResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        print("✅ Success: \(data)")
                        completion(.success(data))
                    case .failure(let error):
                        print("❌ Request Failed: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
        }
}
