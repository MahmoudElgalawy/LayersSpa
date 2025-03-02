//
//  File.swift
//  
//
//  Created by 2B on 12/06/2024.
//

import Foundation
import UIKit

// MARK: - Style Helper

//
@available(iOS 11.0, *)
public extension UIButton {
    
    enum buttonStyle {
        case filled
        case border
        case plain
        case selectedSegmentedControl
        case unSelectedSegmentedControl
        case socialMediaBorder
    }
    
    func applyButtonStyle(_ style: buttonStyle) {
        switch style {
        case .filled:
            filledStyle()
        case .border:
            borderStyle()
        case .plain:
            plainStyle()
        case .socialMediaBorder:
            socialMediaStyle()
        case .selectedSegmentedControl:
            selectedSegmentedStyle()
        case .unSelectedSegmentedControl:
            unSelectedSegmentStyle()
        }
        
    }
}


@available(iOS 11.0, *)
extension UIButton {
    
    // MARK: - Filled Buttons style
    private func selectedSegmentedStyle() {
        titleLabel?.font = .B3Bold
        tintColor = .whiteColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .primaryColor
    }
    
    // MARK: - Filled Buttons style
    private func filledStyle() {
        titleLabel?.font = .B2Bold
        tintColor = .whiteColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .secondaryColor
    }
    
    // MARK: - Bordered Buttons style
    private func borderStyle() {
        titleLabel?.font = .B2Bold
        tintColor = .primaryColor
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .clear
        layer.borderColor = UIColor.primaryColor.cgColor
        layer.borderWidth = 1
    }
    
    // MARK: - Plain Buttons style
    private func plainStyle() {
        titleLabel?.font = .B2Bold
        tintColor = .primaryColor
        backgroundColor = .clear
    }
    
    // MARK: - Plain Buttons style
    private func unSelectedSegmentStyle() {
        titleLabel?.font = .B3Medium
        tintColor = .titlesTF
        backgroundColor = .clear
    }
    
    private func socialMediaStyle() {
        titleLabel?.font = .B2Medium
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .clear
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = 1
    }

}

public extension UIButton {
    func applyImagePaddingConfiguration(_ padding: Int) {
        if #available(iOS 15.0, *) {
            // iOS 15+ implementation
            var configuration = UIButton.Configuration.plain()
            configuration.imagePadding = CGFloat(padding)
            configuration.imagePlacement = .leading
            self.configuration = configuration
        } else {
            // Fallback for earlier iOS versions
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(padding), bottom: 0, right: 0)
        }
    }
}
