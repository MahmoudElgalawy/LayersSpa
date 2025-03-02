//  
//  MyAccountViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import Foundation

/// MyAccount Input & Output
///
typealias MyAccountViewModelType = MyAccountViewModelInput & MyAccountViewModelOutput

/// MyAccount ViewModel Input
///
protocol MyAccountViewModelInput {
    var userProfile: UserData? {get set}
    var onUserProfileFetched: ((UserData?) -> Void)? {get set}
}

/// MyAccount ViewModel Output
///
protocol MyAccountViewModelOutput {
    func getAccountCellInfo(_ index: Int) -> BookingSummerySectionsVM
    func getCellsNum() -> Int
    func fetchUserProfile()
    func updateUserProfile(firstName: String, email: String, phone: String, image: Data?, completion: @escaping (Result<String, Error>) -> Void)
}
