//  
//  WalletViewModel.swift
//  LayersSpa
//
//  Created by 2B on 05/08/2024.
//

import Foundation

// MARK: WalletViewModel

class WalletViewModel {
    let remote = CustomerBalanceRemote()
    
    func getCustomerBalance(completion: @escaping (Int) -> Void) {
        remote.fetchCustomerBalance { result in
            switch result {
            case .success(let balance):
                print("✅ Wallet Balance: \(balance)")
                completion(balance.data)
            case .failure(let error):
                print("❌ Failed to fetch balance: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: WalletViewModel

extension WalletViewModel: WalletViewModelInput {}

// MARK: WalletViewModelOutput

extension WalletViewModel: WalletViewModelOutput {}

// MARK: Private Handlers

private extension WalletViewModel {
    
   
}
