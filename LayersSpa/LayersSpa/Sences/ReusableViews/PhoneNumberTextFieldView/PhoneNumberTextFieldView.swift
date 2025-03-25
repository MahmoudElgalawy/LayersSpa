//
//  PhoneNumberTextFieldView.swift
//  LayersSpa
//
//  Created by marwa on 15/07/2024.
//

import UIKit
import DropDown
import UILayerSpa


class PhoneNumberTextFieldView: UIViewFromNib {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    let dropDown = DropDown()
    let countryCodes: [String: String] = [
        "EGP": "+20",
        "KSA": "+966",
        "UK": "+44"
    ]
    
    var defaultCountryCode: String = "+966" {
            didSet {
                countryLabel.text = defaultCountryCode
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyContainerViewBoarder()
        dropDown.anchorView = countryView // UIView or UIBarButtonItem
        countryLabel.text = countryCodes["KSA"]
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["EGP", "KSA", "UK"]
        dropDown.direction = .bottom
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
               print("Selected item: \(item) at index: \(index)")
               self.countryLabel.text = countryCodes[item] ?? ""
        }
        phoneTextField.addTarget(self, action: #selector(validatePhoneNumber), for: .editingChanged)
        phoneTextField.placeholder = String(localized: "phoneNumberTextField")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        countryView.addGestureRecognizer(tapGesture)
    }
    
    @objc func validatePhoneNumber() {
        if isPhoneNumberValid() {
            phoneTextField.layer.borderColor = UIColor.green.cgColor
        } else {
            phoneTextField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    @objc func viewTapped() {
        dropDown.show()
    }
    
    func applyContainerViewBoarder() {
        
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.border.cgColor
        
        phoneTextField.textColor = .darkTextColor
        phoneTextField.font = .B3Regular
       
//        let attributes = [
//            NSAttributedString.Key.foregroundColor: UIColor.lightText,
//            NSAttributedString.Key.font : UIFont.B3Regular
//        ]
//        
//        phoneTextField.attributedPlaceholder = NSAttributedString(string: phoneTextField.placeholder != nil ? phoneTextField.placeholder! : "Enter your phone number", attributes: attributes)
        
    }
    func isPhoneNumberValid() -> Bool {
        guard let countryCode = countryLabel.text, !countryCode.isEmpty,
              let phoneNumber = phoneTextField.text  else {
            return false
        }
        return phoneNumber.hasPrefix(countryCode)
    }
    
    func getFullPhoneNumber() -> String {
            guard let countryCode = countryLabel.text, !countryCode.isEmpty,
                  let phoneNumber = phoneTextField.text else {
                return ""
            }
            
          //  let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            
            return "\(countryCode)\(phoneNumber)"
        }
    
    
    func setCountryCode(for country: String) {
            switch country {
            case "SA":
                defaultCountryCode = "+966"
            case "EG":
                defaultCountryCode = "+20"
            case "US":
                defaultCountryCode = "+1"
            default:
                defaultCountryCode = "+966"
            }
        }
}
