//
//  File.swift
//  
//
//  Created by marwa on 01/08/2024.
//

import Foundation
import UIKit

public extension UIImage {
    func flipVertically() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        draw(at: .zero)
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return flippedImage
    }
}
