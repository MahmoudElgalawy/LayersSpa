//  
//  WalletViewModelType.swift
//  LayersSpa
//
//  Created by 2B on 05/08/2024.
//

import Foundation

/// Wallet Input & Output
///
typealias WalletViewModelType = WalletViewModelInput & WalletViewModelOutput

/// Wallet ViewModel Input
///
protocol WalletViewModelInput {}

/// Wallet ViewModel Output
///
protocol WalletViewModelOutput {
    func getCustomerBalance(completion: @escaping (Int) -> Void)
}
