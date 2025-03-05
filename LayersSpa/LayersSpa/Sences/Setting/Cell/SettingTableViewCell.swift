//
//  SettingTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import UIKit
import UILayerSpa

class SettingTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var rightIcone: UIImageView!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellIcone: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var showAlertDelegate: AddToCartAlerts?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.roundCorners(radius: 16)
        selectionStyle = .none
        self.switch.transform = CGAffineTransform(scaleX: 0.90, y: 0.70)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(_ setting: settingVM) {
        cellTitle.text = setting.title
        cellIcone.image = setting.icon
        rotateIconBasedOnLanguage()
        switch setting.type {
        case .Delete:
            self.switch.isHidden = true
            rightIcone.isHidden = false
            rightIcone.image = .blackArrow
        case .appLanguage:
            self.switch.isHidden = true
            rightIcone.isHidden = false
            languageUnselectionStyle()
//        case .notifications:
//            self.switch.isHidden = false
//            rightIcone.isHidden = true
//        case .account:
//            self.switch.isHidden = true
//            rightIcone.isHidden = false
//            rightIcone.image = .blackArrow
        }
    }
    
//    private func rotateIconBasedOnLanguage() {
//        let currentLanguage = Locale.preferredLanguages.first ?? "en"
//        let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
//        rightIcone.transform = CGAffineTransform(rotationAngle: rotationAngle)
//    }
    
    func languageSelectionStyle() {
        rightIcone.image = .selectedRadioButton
        containerView.layer.borderColor = UIColor.primaryColor.cgColor
        containerView.layer.borderWidth = 1
        cellTitle.textColor = .darkTextColor
    }
    
    func languageUnselectionStyle() {
        rightIcone.image = .unSelectedRadioButton
        containerView.layer.borderColor = UIColor.whiteColor.cgColor
        containerView.layer.borderWidth = 1
        cellTitle.textColor = .titlesTF
    }
    
    func rotateIconBasedOnLanguage() {
        let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let rotationAngle: CGFloat = savedLanguage == "ar" ? .pi : 0
        rightIcone.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
}

struct settingVM {
    let type: SettingTableViewSectionsType
    let title: String
    let icon: UIImage
}
