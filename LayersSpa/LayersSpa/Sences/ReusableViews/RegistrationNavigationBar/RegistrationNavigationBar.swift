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
}

protocol RegistrationNavigationBarDelegate: AnyObject {
    func back()
}
