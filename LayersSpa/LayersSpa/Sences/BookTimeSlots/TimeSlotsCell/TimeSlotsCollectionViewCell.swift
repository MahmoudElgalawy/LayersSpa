//
//  TimeSlotsCollectionViewCell.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import UIKit
import UILayerSpa

class TimeSlotsCollectionViewCell: UICollectionViewCell, IdentifiableView {
    
    
    @IBOutlet weak var timeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyUnselectedStyle()
    }
    
    func applySelectedStyle() {
        self.roundCorners(radius: 16)
        self.layer.borderColor = UIColor.primaryColor.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .grayLight
    }
    
    func applyUnselectedStyle() {
        self.roundCorners(radius: 16)
        self.layer.borderColor = UIColor.border.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
    }
}

