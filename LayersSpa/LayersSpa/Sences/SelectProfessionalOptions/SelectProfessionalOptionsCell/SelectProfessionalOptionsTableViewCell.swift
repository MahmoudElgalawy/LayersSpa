//
//  SelectProfessionalOptionsTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import UIKit
import UILayerSpa

class SelectProfessionalOptionsTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImage: UIImageView!
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.roundCorners(radius: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell (_ option: SelectProfessionalOptionsVM) {
        cellImage.image = option.cellImage
        titleLabel.text = option.title
        subTitleLabel.text = option.subTitle
    }
    
    func configureCellForRecharge(_ item: BookingSummerySectionsVM){
        subTitleLabel.isHidden = true
        cellImage.image = item.sectionIcon
        titleLabel.text = item.sectionTitle
    }
    
}

struct SelectProfessionalOptionsVM {
    let cellImage: UIImage
    let title: String
    let subTitle: String
}
