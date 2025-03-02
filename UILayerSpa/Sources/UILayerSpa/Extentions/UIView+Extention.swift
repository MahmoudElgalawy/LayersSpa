//
//  File.swift
//  
//
//  Created by marwa on 14/07/2024.
//

import Foundation
import UIKit

public extension UIView {
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.locations = [0.0, 0.4, 1.0] 
        gradientLayer.frame = self.bounds
    
        if let sublayers = self.layer.sublayers {
            for layer in sublayers where layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        DispatchQueue.main.async {
                   gradientLayer.frame = self.bounds
               }
    }
}

public extension UIView {
    
    func addButton(_ button: UIButton , _ tag: Int) {
        button.tag = tag
        addSubview(button)
    }
    
    func removeButton(_ button: UIButton , _ tag: Int) {
        if let viewWithTag = viewWithTag(tag) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func roundTopCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func roundBottomCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
}
