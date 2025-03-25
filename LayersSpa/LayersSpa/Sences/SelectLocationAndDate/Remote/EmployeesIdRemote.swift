//
//  EmployeesIdRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 30/01/2025.
//

import Foundation
import Alamofire

 protocol EmployeeIdRemoteProtocol {
    func fetchEmployeeId(skillIDs: [String], completion: @escaping (Result<[Int], Error>) -> Void)
}

class EmployeeIdRemote: EmployeeIdRemoteProtocol {
    
    private let baseURL = "https://testhr.vodoglobal.com"
    private let path = "/api/v1/employees-skill-arr"
    
    
     func fetchEmployeeId(skillIDs: [String], completion: @escaping (Result<[Int], Error>) -> Void) {
        let url = "\(baseURL)\(path)"
        
        var parameters: Parameters = [
            "data_scope": "paginate"
        ]
        
        // إضافة القيم كمصفوفة مع المفاتيح المناسبة
        for (index, id) in skillIDs.enumerated() {
            parameters["service_skill_id[\(index)]"] = id
        }
        
        let headers: HTTPHeaders = [
            "secure_business_key": "4765066450c0bd66325.48403130",
            "uuid": "630ca2f4885f8",
            "Accept-Language": "en"
        ]
        
        print("🔵 Sending request to: \(url)")
        print("📌 Parameters: \(parameters)")
        print("📌 Headers: \(headers)")

        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ServicesEmployeeModel.self) { response in
                print("✅ Success: \(response)")
                switch response.result {
                case .success(let data):
                    print("✅ Success: \(data)")
                    completion(.success(data.response.data.map{$0.userID!}))
                case .failure(let error):
                    print("❌ Request Failed In Employee : \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
    }
}


//https://testcalendar.vodoglobal.com/api/v2/get-available-employee-times

