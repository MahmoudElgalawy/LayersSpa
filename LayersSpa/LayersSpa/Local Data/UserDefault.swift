//
//  UserDefault.swift
//  LayersSpa
//
//  Created by marwa on 03/08/2024.
//

import Foundation
import Networking

class Defaults {
    
    public static let sharedInstance = Defaults()
    private var userDefaults:UserDefaults
    
    private init(){
        userDefaults = UserDefaults.standard
    }
    
//    Unable to Decode Notes (valueNotFound(Swift.Dictionary<Swift.String, Any>, Swift.DecodingError.Context(codingPath: [], debugDescription: "Cannot get keyed decoding container -- found null value instead", underlyingError: nil)))
    var branchId: BrancheVM? {
        get {
            if let data = UserDefaults.standard.data(forKey: "branchId") {
                do {
                    let decoder = JSONDecoder()
                    let branchData = try decoder.decode(BrancheVM.self, from: data)
                    return branchData

                } catch {
                    print("Unable to Decode Notes (\(error))")
                    return nil
                }
            }
            return nil
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                userDefaults.set(data, forKey: "branchId")
                
            } catch {
                print("Unable to Encode Array of Notes (\(error))")
                
            }
        }
    }
    
    var userData: loginVM? {
        get {
            if let data = UserDefaults.standard.data(forKey: "userData") {
                do {
                    let decoder = JSONDecoder()
                    let userData = try decoder.decode(loginVM.self, from: data)
                    return userData

                } catch {
                    print("Unable to Decode Notes (\(error))")
                    return nil
                }
            }
            return nil
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                userDefaults.set(data, forKey: "userData")
                
            } catch {
                print("Unable to Encode Array of Notes (\(error))")
                
            }
        }
    }
    
    var cartId: String {
        get {
            return userDefaults.string(forKey: "cartId") ?? ""
        }
        set {
            userDefaults.set(newValue, forKey: "cartId")
        }
    }
    
    func isLoggedIn() -> Bool {
            return userDefaults.bool(forKey: "isLoggedIn") // استرجاع حالة تسجيل الدخول
        }
    
    func navigateToAppoinment(_ navigate: Bool) {
        userDefaults.set(navigate, forKey: "navigateToAppoinment")
    }
    
    func getIsNavigateToAppoinment() -> Bool {
        userDefaults.bool(forKey: "navigateToAppoinment")
    }

    func logout() {
        userDefaults.set(false, forKey: "isLoggedIn")
    }
    
    func login() {
        userDefaults.set(true, forKey: "isLoggedIn")
    }
    
    func setRunOnce(_ run: Bool) {
        userDefaults.set(run, forKey: "runOnce")
    }
    
    func getRunOnce() -> Bool {
        return userDefaults.bool(forKey: "runOnce")
    }
    
    struct Constants {
        static let isLoggedInUserDefaults = "isLoggedIn"
    }

}
