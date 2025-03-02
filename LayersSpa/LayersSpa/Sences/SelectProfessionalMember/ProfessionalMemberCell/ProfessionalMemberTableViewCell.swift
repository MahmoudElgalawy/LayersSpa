//
//  ProfessionalMemberTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class ProfessionalMemberTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var radioButtonImage: UIImageView!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var reviewLable: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        unSelectedStyle()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func selectedStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.primary.cgColor
        containerView.layer.borderWidth = 1
        radioButtonImage.image = .selectedRadioButton
    }
    
    func unSelectedStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.whiteColor.cgColor
        containerView.layer.borderWidth = 1
        radioButtonImage.image = .unSelectedRadioButton
    }
    
    func configeCell(_ employee: Employee) {
           
        let employeeImageUrl = URL(string: "\(employee.empData.profileInfo.profileImage)")
        self.memberImage.kf.setImage(with:employeeImageUrl){ result in
            switch result {
            case .success(let value):
                self.memberImage.image = value.image.circleMasked
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
            }
    }
        memberNameLabel.text = employee.empData.name
        ratingLabel.text = "4.8"
        reviewLable.text = "(80)"
    }
    
}


