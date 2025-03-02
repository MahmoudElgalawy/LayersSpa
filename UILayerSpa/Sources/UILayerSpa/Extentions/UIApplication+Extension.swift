//
//  File.swift
//  
//
//  Created by marwa on 19/07/2024.
//

import Foundation
import UIKit

public extension UIApplication {
    
    // A computed property to get the current window
    var currentWindow: UIWindow? {
        // iOS 13 and later
        if #available(iOS 13, *) {
            return self.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .filter { $0.isKeyWindow }.first
        } else {
            // iOS 12 and earlier
            return self.keyWindow
        }
    }
}

