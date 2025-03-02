//  
//  VerificationViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import Foundation

/// Verification Input & Output
///
typealias VerificationViewModelType = VerificationViewModelInput & VerificationViewModelOutput

/// Verification ViewModel Input
///
protocol VerificationViewModelInput {}

/// Verification ViewModel Output
///
protocol VerificationViewModelOutput {
    func updatePassword(phone: String, password: String, otp: String,
                        completion: @escaping (Bool, String) -> Void)
    func getOTP(phone: String)
    func checkOTP(phone: String,otp: Int, completion: @escaping (Bool)->())
}
