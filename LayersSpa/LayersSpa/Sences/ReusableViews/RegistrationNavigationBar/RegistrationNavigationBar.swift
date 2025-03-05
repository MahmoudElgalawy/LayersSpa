//
//  RegistrationNavigationBar.swift
//  LayersSpa
//
//  Created by marwa on 15/07/2024.
//

import UIKit
import UILayerSpa

class RegistrationNavigationBar: UIViewFromNib {
    
    @IBOutlet private weak var backButton: UIButton!
    var navDelegate: RegistrationNavigationBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindBackButton()
        rotateImageBasedOnLanguage()
    }
    
    func bindBackButton() {
        backButton.addTarget(self, action: #selector(backIsTapped), for: .touchUpInside)
    }
    
    func hideBackButton(){
        backButton.isHidden = true
    }
    
    @objc func backIsTapped() {
        navDelegate?.back()
    }
    
    private func rotateImageBasedOnLanguage() {
            let currentLanguage = Locale.preferredLanguages.first ?? "en"
            let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
            backButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}

protocol RegistrationNavigationBarDelegate: AnyObject {
    func back()
}
