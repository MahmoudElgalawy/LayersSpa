//
//  DiscoundCodeTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import UIKit
import UILayerSpa

class DiscoundCodeTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var discoundCodeTF: UITextField!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.roundCorners(radius: 16)
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.border.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
