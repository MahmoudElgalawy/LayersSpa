//  
//  VerificationViewModel.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import Foundation

// MARK: VerificationViewModel

class VerificationViewModel:VerificationViewModelOutput,VerificationViewModelInput {
    var remote: VerficationRemoteProtocol!
       
       init(remote: VerficationRemoteProtocol) {
           self.remote = remote
       }
       


    func updatePassword(phone: String, password: String, otp: String,
                            completion: @escaping (Bool, String) -> Void) {
            print("🔵 Attempting to reset password...")
            
            remote.resetPassword(phone, password, otp) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    print("✅ Success Response: \(data)")
                    if data.status {
                        DispatchQueue.main.async {
                            // تمرير true مع رسالة النجاح
                            completion(true, "Password Reset Successfully")
                        }
                    } else {
                        DispatchQueue.main.async {
                            // تمرير false مع رسالة الفشل
                            completion(false, data.message ?? "Unknown error occurred")
                        }
                    }
                    
                case .failure(let error):
                    print("❌ Request Failed: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        // تمرير false مع رسالة الخطأ
                        completion(false, error.localizedDescription)
                    }
                }
            }
        }
    
    func getOTP(phone: String){
        remote.getOTP(phone) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func checkOTP(phone: String,otp: Int, completion: @escaping (Bool)->()){
        remote.checkOTP(phone, otp: otp) { [weak self] result in
            switch result {
            case .success(let data):
                if data.status{
                    completion(true)
                }else{
                    completion(false)
                }
               
                print(data)
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: Private Handlers

private extension VerificationViewModel {}
