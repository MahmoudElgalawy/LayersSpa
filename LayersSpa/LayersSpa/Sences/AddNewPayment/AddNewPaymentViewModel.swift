//  
//  AddNewPaymentViewModel.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import Foundation
import Networking

// MARK: AddNewPaymentViewModel

class AddNewPaymentViewModel {
    
    private var paymentRemote: PaymentRemoteProtocol
    
    init(paymentRemote: PaymentRemoteProtocol =  PaymentRemote(network: AlamofireNetwork())) {
        self.paymentRemote = paymentRemote
    }
    
    
    
   
}

// MARK: AddNewPaymentViewModel

extension AddNewPaymentViewModel: AddNewPaymentViewModelInput {}

// MARK: AddNewPaymentViewModelOutput

extension AddNewPaymentViewModel: AddNewPaymentViewModelOutput {}

// MARK: Private Handlers

private extension AddNewPaymentViewModel {}
