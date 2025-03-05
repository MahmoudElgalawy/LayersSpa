//
//  Bundel.swift
//  LayersSpa
//
//  Created by Mahmoud Ahmed Hefny on 04/03/2025.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    private let userDefaults = UserDefaults.standard
    private let key = "SelectedLanguage"
    
    var currentLanguage: String {
        return userDefaults.string(forKey: key) ?? "en"
    }
    
    func setLanguage(_ code: String) {
        userDefaults.set(code, forKey: key)
        userDefaults.synchronize()
    }
}
