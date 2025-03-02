//
//  File.swift
//  
//
//  Created by 2B on 13/06/2024.
//

import Foundation
import UIKit

@available(iOS 11.0, *)
public extension UILabel {

    enum labelStyle {
        case onboardingTitle
        case onboardingSubTitle
        case onboardingDetails
        case textFieldTitleLabel
        case screenTitle
        case subtitleLabel
        case coloredSubtitle
        case alertTitle
        case userName
        case welcomeLabel
    }

    func applyLabelStyle(_ style: labelStyle) {
        switch style {
        
        case .onboardingTitle:
            onboardingTitleLabel()
        case .onboardingSubTitle:
            onboardingSubTitleLabel()
        case .onboardingDetails:
            onboardingDetailsLabel()
        case .textFieldTitleLabel:
            textFieldTitleLabel()
        case .screenTitle:
            screenTitleLabel()
        case .subtitleLabel:
            screenSubTitleLabel()
        case .coloredSubtitle:
            screenColoredSubTitleLabel()
        case .alertTitle:
            alertTitleLabel()
        case .userName:
            userNameLabel()
        case .welcomeLabel:
            welcomeLabel()
        }
    }
}

@available(iOS 11.0, *)
extension UILabel {

    private func userNameLabel() {
        textColor = .darkTextColor
        font = .T3Bold
    }
    private func welcomeLabel() {
        textColor = .darkTextColor
        font = .B4Regular
    }
    private func onboardingTitleLabel() {
        textColor = .secondaryColor
        font = .h2Bold
    }
    
    private func screenTitleLabel() {
        textColor = .darkTextColor
        font = .h3Medium
    }
    
    private func screenSubTitleLabel() {
        textColor = .darkTextColor
        font = .B2Regular
    }
    
    private func screenColoredSubTitleLabel() {
        textColor = .primaryColor
        font = .B2Medium
    }
    
    
    private func textFieldTitleLabel() {
        textColor = .titlesTF
        font = .B3Medium
    }
    
    private func onboardingSubTitleLabel() {
        textColor = .whiteColor
        font = .h3Regular
    }
    
    private func onboardingDetailsLabel() {
        textColor = .whiteColor
        font = .B3Regular
    }
    
    private func alertTitleLabel() {
        textColor = .darkTextColor
        font = .T3Bold
    }
}

public extension UILabel {
    
    func applyLineSpacing(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.lineSpacing = 4
          
          let attributes: [NSAttributedString.Key: Any] = [
              .paragraphStyle: paragraphStyle,
              .font: UIFont.B4Regular
          ]
          
        let attributedString = NSAttributedString(string: text, attributes: attributes)
          self.attributedText = attributedString
    }
}
