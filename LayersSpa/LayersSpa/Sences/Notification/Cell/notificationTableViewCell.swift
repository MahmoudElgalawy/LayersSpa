//
//  notificationTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import UIKit
import UILayerSpa

class notificationTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet private weak var descLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var notificationImage: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundCorners(radius: 16)
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(_ info: NotificationVM) {
        notificationImage.image = info.notifImage
        titleLabel.text = info.notifTitle
        descLabel.text = info.notifDesc
    }
    
}

struct NotificationVM {
    let notifImage: UIImage
    let notifTitle: String
    let notifDesc: String
}
