//
//  File.swift
//  
//
//  Created by marwa on 15/07/2024.
//

import Foundation
import UIKit


// MARK: - RightImgIconeTextField

@available(iOS 11.0, *)
@IBDesignable class RightImgIconeTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 44)
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= leftPadding
        return textRect
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    
    func updateView() {
        if let image = rightImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleToFill
            imageView.image = image
            leftView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
}

