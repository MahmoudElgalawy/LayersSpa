//
//  AccountTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 04/08/2024.
//

import UIKit
import UILayerSpa

class AccountTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func clearLineView() {
        lineView.backgroundColor = .clear
    }
    
    func configeCell(_ cellInfo: BookingSummerySectionsVM) {
        cellImage.image = cellInfo.sectionIcon
        cellTitle.text = cellInfo.sectionTitle
        rotateImageBasedOnLanguage()
    }
    
    private func rotateImageBasedOnLanguage() {
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
        arrowImage.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
}
