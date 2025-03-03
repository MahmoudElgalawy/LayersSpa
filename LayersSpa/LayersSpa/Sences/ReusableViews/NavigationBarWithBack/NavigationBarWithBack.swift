//
//  NavigationBarWithBack.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import Foundation
import UILayerSpa
import UIKit

class NavigationBarWithBack: UIViewFromNib {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var backButton: UIButton!
    weak var delegate: RegistrationNavigationBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindBackButton()
        rotateButtonBasedOnLanguage()
    }
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func bindBackButton() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc func backTapped() {
        delegate?.back()
    }
    
    private func rotateButtonBasedOnLanguage() {
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
        backButton.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}
