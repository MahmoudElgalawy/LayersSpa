//
//  PaymentOptionsTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import UIKit
import UILayerSpa

class PaymentOptionsTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        unSelectedStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ item: BookingSummerySectionsVM) {
        print("Configuring cell with title: \(item.sectionTitle)")
        iconImage.image = item.sectionIcon
        titleLabel.text = item.sectionTitle
    }
    
    func selectedStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.primary.cgColor
        containerView.layer.borderWidth = 1
        titleLabel.textColor = UIColor.darkTextColor
    }
    
    func unSelectedStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.border.cgColor
        containerView.layer.borderWidth = 1
        titleLabel.textColor = UIColor.titlesTF.withAlphaComponent(0.8)
    }
    
}
