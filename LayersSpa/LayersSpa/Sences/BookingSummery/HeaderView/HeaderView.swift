//
//  HeaderView.swift
//  LayersSpa
//
//  Created by marwa on 01/08/2024.
//

import UIKit
import UILayerSpa

class HeaderView: UIViewFromNib {
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureHeaderView(_ item: BookingSummerySectionsVM, _ isExpanded: Bool) {
        iconImage.image = item.sectionIcon
        titleLabel.text = item.sectionTitle
        if isExpanded {
            arrowImage.image = .topArrow
            lineView.isHidden = false
        }else {
            arrowImage.image = .topArrow.flipVertically()
            lineView.isHidden = true
        }
       
        
    }
}
