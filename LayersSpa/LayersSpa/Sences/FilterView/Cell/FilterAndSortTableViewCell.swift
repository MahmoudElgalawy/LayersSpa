//
//  FilterAndSortTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 27/07/2024.
//

import UIKit
import UILayerSpa

class FilterAndSortTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var radioButtonImage: UIImageView!
    var branch: BrancheVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        unSelectedStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(_ title: String) {
        titleLabel.text = title
    }
    
    func configeCellForBranches(_ branch: BrancheVM) {
        titleLabel.text = branch.name
        self.branch = branch
    }
    
    func getSelectedBranch() -> BrancheVM? {
        return branch
    }
    
    func selectedStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.primary.cgColor
        containerView.layer.borderWidth = 1
        titleLabel.textColor = UIColor.darkTextColor
        radioButtonImage.image = .selectedRadioButton
    }
    
    func unSelectedStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.border.cgColor
        containerView.layer.borderWidth = 1
        titleLabel.textColor = UIColor.titlesTF.withAlphaComponent(0.8)
        radioButtonImage.image = .unSelectedRadioButton
    }
    
}
//func selectedStyle() {
//    self.accessoryType = .checkmark // إضافة علامة الاختيار
//    self.backgroundColor = .lightGray // تغيير لون الخلفية (اختياري)
//}
//
//func unSelectedStyle() {
//    self.accessoryType = .none // إزالة علامة الاختيار
//    self.backgroundColor = .white // إعادة لون الخلفية إلى الوضع الطبيعي (اختياري)
//}
