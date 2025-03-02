//
//  EmptyStateView.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import UIKit
import UILayerSpa

class EmptyStateView: UIViewFromNib {

    @IBOutlet private weak var viewButton: UIButton!
    @IBOutlet private weak var viewSubtitleLabel: UILabel!
    @IBOutlet private weak var viewTitleLabel: UILabel!
    @IBOutlet private weak var viewImage: UIImageView!
    
    weak var delegate: EmptyStateDelegation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindViewButton()
    }
    
    func configeView(_ image: UIImage, _ title: String, _ subtitle: String, _ buttonTitle: String = "") {
        
        viewImage.image = image
        viewTitleLabel.text = title
        viewSubtitleLabel.text = subtitle
        
        if buttonTitle != "" {
            viewButton.isHidden = false
            viewButton.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private func bindViewButton() {
        viewButton.isHidden = true
        viewButton.applyButtonStyle(.filled)
        viewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        delegate?.emptyViewButtonTapped()
    }
    
}

protocol EmptyStateDelegation: AnyObject {
    func emptyViewButtonTapped()
}
