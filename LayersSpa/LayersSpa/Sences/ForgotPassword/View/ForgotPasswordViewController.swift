//  
//  ForgotPasswordViewController.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import UIKit
import UILayerSpa
import Networking

class ForgotPasswordViewController: UIViewController, CustomAlertDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBar: RegistrationNavigationBar!
    @IBOutlet weak var emailTF: PhoneNumberTextFieldView!
    @IBOutlet weak var blanckPhone: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    
    
    // MARK: Properties

    private var viewModel: ForgotPasswordViewModelType
    var checkViewModel: SignupViewModelType = SignupViewModel()
    // MARK: Init

    init(viewModel: ForgotPasswordViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = String(localized: "ForgotTitle")
        subTitleLabel.text = String(localized: "resetTitle")
        phoneNumberLabel.text = String(localized: "phoneNumberLbl")
        blanckPhone.text = String(localized: "Phoneblank")
        resetPasswordButton.setTitle(String(localized: "ForgotTitle"), for: .normal)
        
        blanckPhone.isHidden = true
        emailTF.phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emailTF.heightAnchor.constraint(equalTo:emailTF.phoneTextField.heightAnchor).isActive = true
        emailTF.phoneTextField.layer.cornerRadius = 15
        emailTF.layer.cornerRadius = 15
        emailTF.layer.borderColor = UIColor.border.cgColor
        emailTF.clipsToBounds = true
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        navBar.navDelegate = self
        bindLabels()
        bindResetPasswordButton()
        bindViewModel()
    }
    
    @objc func textFieldDidChange() {
        // إرجاع لون البوردر للحالة الطبيعية
//        phoneNumberTFView.layer.borderColor = UIColor.border.cgColor
////        phoneNumberTFView.layer.borderWidth = 1.0
//        warningPhone.isHidden = true
//        warningPhone.text = "Phone can not be blank"
        blanckPhone.isHidden = true
        emailTF.layer.borderColor = UIColor.border.cgColor
    }
}

// MARK: - Actions

extension ForgotPasswordViewController {
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            self.showAlert(msg: alertMessage)
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            if result.state {
//                let alert = CustomAlertViewController()
//                alert.alertDelegate = self
//                alert.show("Password Reset Successfully", "Your password has been reset. You can now sign in with your new password.", buttonTitle: "Sign in")
            }
        }
        
        viewModel.onUpdateLoadingStatus = { [weak self] state in
            
            guard let self = self else { return }
            
            switch state {
            case .error:
                print("error")
                activityIndicator.stopAnimating()
            case .loading:
                print("loading")
                activityIndicator.startAnimating()
            case .loaded:
                print("loaded")
                activityIndicator.stopAnimating()
            case .empty:
                print("empty")
            }
        }
    }
    
}

// MARK: - Configurations

extension ForgotPasswordViewController {
    
    func bindLabels() {
        phoneNumberLabel.applyLabelStyle(.textFieldTitleLabel)
        titleLabel.applyLabelStyle(.screenTitle)
        subTitleLabel.applyLabelStyle(.subtitleLabel)
        phoneNumberLabel.applyLabelStyle(.textFieldTitleLabel)
        //emailTF.applyBordertextFieldStyle("Enter Your Phone Number")
        
    }
    
    func bindResetPasswordButton() {
        resetPasswordButton.applyButtonStyle(.filled)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordIsTapped), for: .touchUpInside)
    }

}

// MARK: - Private Handlers

private extension ForgotPasswordViewController {
    
    @objc func resetPasswordIsTapped() {
        let phone = emailTF.getFullPhoneNumber()
        //let phone = emailTF.text ?? ""
        if phone.count > 4{
               
               // تخزين الإيميل في UserDefaults
               UserDefaults.standard.set(phone, forKey: "phone")
               
            let vc = VerificationViewController(viewModel: VerificationViewModel(remote: VerficationRemote(network: AlamofireNetwork())))
            vc.phoneNumber = phone
            viewModel.resetPassword(UserDefaults.standard.string(forKey: "phone") ?? "")
           // vc.viewModel.getOTP(phone: phone)
            vc.register = false
            self.navigationController?.pushViewController(vc, animated: true)
            
           } else {
//               showError("Invalid", "Phone Numbeer is required")
               blanckPhone.isHidden = false
               emailTF.layer.borderColor = UIColor.redColor.cgColor
           }
    }
    
//    func showError(_ title: String, _ msg: String) {
//        UIAlertController.Builder()
//            .title(title)
//            .message(msg)
//            .addOkAction()
//            .show(in: self)
//    }
}

extension ForgotPasswordViewController: RegistrationNavigationBarDelegate {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(msg:String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "Invalid"), msg, buttonTitle: String(localized: "Retry"),navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
    
    func alertButtonClicked() {
    }
    
}

