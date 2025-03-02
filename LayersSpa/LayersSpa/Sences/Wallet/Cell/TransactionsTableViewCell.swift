//
//  TransactionsTableViewCell.swift
//  LayersSpa
//
//  Created by 2B on 05/08/2024.
//

import UIKit
import UILayerSpa

class TransactionsTableViewCell: UITableViewCell, IdentifiableView {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cellIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundCorners(radius: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
