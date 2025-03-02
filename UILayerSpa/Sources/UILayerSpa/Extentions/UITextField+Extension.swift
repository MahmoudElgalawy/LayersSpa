//
//  File.swift
//  
//
//  Created by 2B on 13/06/2024.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
public extension UITextField {
    
    func applyBordertextFieldStyle(_ placeholder: String) {
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.border.cgColor
        
        textColor = .darkTextColor
        font = .B3Regular
        
        backgroundColor = .clear
        
        self.placeholder = placeholder
        let placeholderText = self.placeholder ?? placeholder
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.titlesTF.withAlphaComponent(0.5),
            .font: UIFont.B3Regular 
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}

