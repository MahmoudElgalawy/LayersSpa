//
//  PaymentHeaderView.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import Foundation
import UILayerSpa
import UIKit

class PaymentHeaderView: UIViewFromNib {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var addNewButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindAddNewButton()
    }
    
    
    func configureView(_ title: String,_ isShowButton: Bool) {
        titleLabel.text = title
        
        if isShowButton {
            addNewButton.isHidden = false
        } else {
            addNewButton.isHidden = true
        }
        
        addNewButton.setTitle(String(localized: "addNew"), for: .normal)
    }
    
    func bindAddNewButton() {
        addNewButton.addTarget(self, action: #selector(addNewTapped), for: .touchUpInside)
    }
    
    @objc func addNewTapped() {
        NotificationCenter.default.post(name: .addNewButtonPressed, object: nil)
    }
}
