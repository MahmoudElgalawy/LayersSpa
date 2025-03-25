//  
//  MyAccountViewModel.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//
import Foundation

// MARK: MyAccountViewModel

class MyAccountViewModel {
    
    private let remote: MyAccountRemoteProtocol
    
    var userProfile: UserData?
    
    var onUserProfileFetched: ((UserData?) -> Void)?
    
    init(remote: MyAccountRemoteProtocol = MyAccountRemote()) {
        self.remote = remote
    }
    
    func fetchUserProfile() {
        remote.fetchUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.userProfile = profile.data
                    self?.onUserProfileFetched?(profile.data)
                    print("user data =============\(profile)")
                case .failure(let error):
                    print("❌ Error fetching user profile: \(error.localizedDescription)")
                    self?.onUserProfileFetched?(nil)
                }
            }
        }
    }

    func updateUserProfile(firstName: String, email: String, phone: String, image: Data?, completion: @escaping (Result<String, Error>) -> Void) {
        
        remote.updateUserProfile(token: (Defaults.sharedInstance.userData?.token) ?? "0", firstName: firstName, email: email, phone: phone, image: image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_): break
//                    self.userProfile?.firstName = firstName
//                    self.userProfile?.lastName = lastName
//                    self.userProfile?.email = email
//                    self.userProfile?.phone = phone
//                    guard let image = self.userProfile?.image else{return}
//                    self.userProfile?.image = image
                case .failure(let error):
                    print("❌ Error updating profile: \(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    completion(result)
                }
               
            }
        }
    }

    
    var myAccountOptions: [BookingSummerySectionsVM] = [
//        BookingSummerySectionsVM(sectionIcon: .profile, sectionTitle: "My profile"),
//        BookingSummerySectionsVM(sectionIcon: .wallet, sectionTitle: "Wallet"),
//        BookingSummerySectionsVM(sectionIcon: .setting, sectionTitle: "Account settings"),
//        BookingSummerySectionsVM(sectionIcon: .about, sectionTitle: "About Layers"),
//        BookingSummerySectionsVM(sectionIcon: .terms, sectionTitle: "Terms of Use"),
//        BookingSummerySectionsVM(sectionIcon: .policy, sectionTitle: "Privacy policy"),
//        BookingSummerySectionsVM(sectionIcon: .signout, sectionTitle: "Sign out")
        BookingSummerySectionsVM(sectionIcon: .profile, sectionTitle: String(localized: "myProfile")),
        BookingSummerySectionsVM(sectionIcon: .setting, sectionTitle: String(localized: "accountSettings")),
        BookingSummerySectionsVM(sectionIcon: .wallet, sectionTitle: String(localized: "wallet")),
        BookingSummerySectionsVM(sectionIcon: .signout, sectionTitle: UserDefaults.standard.bool(forKey: "guest") ? String(localized: "LoginButton") : String(localized: "signOut"))
    ]
}

// MARK: MyAccountViewModelOutput

extension MyAccountViewModel: MyAccountViewModelOutput,MyAccountViewModelInput {
    
    func getAccountCellInfo(_ index: Int) -> BookingSummerySectionsVM {
        return myAccountOptions[index]
    }
    
    func getCellsNum() -> Int {
        return myAccountOptions.count
    }
}
