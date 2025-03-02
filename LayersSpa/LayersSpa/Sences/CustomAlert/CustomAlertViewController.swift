//
//  CustomAlertViewController.swift
//  LayersSpa
//
//  Created by marwa on 19/07/2024.
//

import UIKit
import Foundation
import UILayerSpa

class CustomAlertViewController: UIViewController {
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var alertSubTitle: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigateButton: UIButton!
    
    var titleText = ""
    var subTitle = ""
    var buttonTitle = ""
    var navigateButtonTitle = ""
    var buttonColor: UIColor = .primaryColor
    var image: UIImage = .alertImage
    var alertDelegate: CustomAlertDelegate?
    var navigateDelegate: CustomAlertDelegate?
    var flag = true
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateButton.isHidden = flag
        applyStyle()
    }
    
    func show(_ title: String, _ subtitle: String, buttonTitle: String, navigateButtonTitle: String, _ buttonColor: UIColor = .primaryColor, _ image: UIImage = .alertImage, flag: Bool) {
        
        self.titleText = title
        self.subTitle = subtitle
        self.buttonTitle = buttonTitle
        self.buttonColor = buttonColor
        self.image = image
        self.navigateButtonTitle = navigateButtonTitle
        self.flag = flag
        
//       
        
        
        guard let window = UIApplication.shared.currentWindow else {
            print("No current window found")
            return
        }
        guard let rootViewController = window.rootViewController else {
            print("No root view controller found")
            return
        }
        
        if presentedViewController == nil {
            rootViewController.present(self, animated: true, completion: nil)
        }
    }
    
    func applyStyle() {
        print("✅ Button target added!")
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.roundCorners(radius: 24)
        alertButton.setTitle(buttonTitle, for: .normal)
        alertButton.applyButtonStyle(.filled)
        alertButton.addTarget(self, action: #selector(alertButtonTapped), for: .touchUpInside)
        navigateButton.setTitle(navigateButtonTitle, for: .normal)
        navigateButton.applyButtonStyle(.filled)
        navigateButton.addTarget(self, action: #selector(navigateButtonTapped), for: .touchUpInside)
        alertTitle.applyLabelStyle(.alertTitle)
        alertSubTitle.applyLabelStyle(.textFieldTitleLabel)
        alertTitle.text = titleText
        alertSubTitle.text = subTitle
        alertButton.backgroundColor = buttonColor
        navigateButton.backgroundColor = buttonColor
        alertImage.image = image
        if !flag  {
            viewHeight.constant = 380
        }else{
            viewHeight.constant = 300
        }
        
        
        
        

    }

}


extension CustomAlertViewController {
    @objc func alertButtonTapped() {
        print("🚀 Button Clicked!")
        alertDelegate?.alertButtonClicked()
        self.dismiss(animated: true)
    }
    
    @objc func navigateButtonTapped() {
        print("🚀 Navigate Button Clicked!")
        navigateDelegate?.alertButtonClicked()
        self.dismiss(animated: true)
    }
}

protocol CustomAlertDelegate {
    func alertButtonClicked ()
}
