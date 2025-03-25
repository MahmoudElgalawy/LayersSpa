//
//  VerficationRemote.swift
//  LayersSpa
//
//  Created by Mahmoud on 29/01/2025.
//

import Foundation
import Alamofire
import Networking

 protocol VerficationRemoteProtocol {
    func resetPassword(_ phone: String, _ password: String,_ otp: String, completion: @escaping (Result<ResetPassword, Error>) -> Void)
    func getOTP(_ phoneNumber: String, completion: @escaping (Result<OTPResponse, Error>) -> Void)
    func checkOTP(_ phoneNumber: String,otp: Int, completion: @escaping (Result<OTPVerificationResponse, Error>) -> Void)
}

/// Login: Remote Endpoints
///
public class VerficationRemote: Remote, VerficationRemoteProtocol {

     func resetPassword(_ phone: String,_ newPassword: String,_ otp: String, completion: @escaping (Result<ResetPassword, Error>) -> Void) {
        let baseURL = "https://taccounting.vodoerp.com"
        let path = "/api/business_users/forgot_password"
        
        let parameters: Parameters = [
            "phone": phone,
            "new_password": newPassword,
            "code": otp
        ]
        
        let headers: HTTPHeaders = [
            "secure-business-key": Settings.secureBusinessKey,
            "platform": Settings.platform,
            "platform-key": Settings.platformKey,
            "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)",
            "apikey": "efe2db322a53"
        ]

        let url = "\(baseURL)\(path)"

        print("🔵 Sending request to: \(url)")
        print("📌 Parameters: \(parameters)")
        print("📌 Headers: \(headers)")

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: ResetPassword.self) { response in
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
    
     func getOTP(_ phoneNumber: String, completion: @escaping (Result<OTPResponse, Error>) -> Void) {
       let path = "https://taccounting.vodoerp.com/api/customers/send_otp"
       let parameters: Parameters = ["phone": Int(phoneNumber)!]
       let headers: HTTPHeaders = [ "secure-business-key": Settings.secureBusinessKey,"apikey": "efe2db322a53", "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"]
//
//       let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters, header: headers, encoderType: JSONEncoding.default)
        
         AF.request(path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
             .validate()
             .responseDecodable(of: OTPResponse.self) { response in
                 switch response.result {
                 case .success(let data):
                     print("✅ Success: \(data)")
                    
                 case .failure(let error):
                     print("❌ Request to get otp Failed: \(error.localizedDescription)")
                 }
             }
      
   }
    
    
    func checkOTP(_ phoneNumber: String,otp: Int, completion: @escaping (Result<OTPVerificationResponse, Error>) -> Void) {
      let path = "https://taccounting.vodoerp.com/api/customers/confirm_otp"
        let parameters: Parameters = ["phone": Int(phoneNumber)!,"code": otp]
      let headers: HTTPHeaders = [ "secure-business-key": Settings.secureBusinessKey,"apikey": "efe2db322a53", "Accept-Language": "\((UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String)!)"]
//
//       let request = LayersApiRequest(method: .post, base: Settings.registrationsApiBaseURL, path: path, parameters: parameters, header: headers, encoderType: JSONEncoding.default)
       
        AF.request(path, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: OTPVerificationResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("✅ Success: \(data)")
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                    print("❌ Request Failed: \(error.localizedDescription)")
                }
            }
     
  }
}


//https://testhr.vodoglobal.com/api/v1/employees-skill-arr?service_skill_id[]=2&service_skill_id[]=5&data_scope=paginate
