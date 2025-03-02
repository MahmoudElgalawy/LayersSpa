//
//  OrderSummeryTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import UIKit
import UILayerSpa

class OrderSummeryTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundCorners(radius: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
