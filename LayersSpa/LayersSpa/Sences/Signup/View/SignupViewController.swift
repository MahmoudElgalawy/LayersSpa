//
//  SignupViewController.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import UIKit
import UILayerSpa
import Networking

class SignupViewController: UIViewController, CustomAlertDelegate {

    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var haveAccountLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var phoneNumberTFView: PhoneNumberTextFieldView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningPhone: UILabel!
    
    // MARK: Properties
    
    private var viewModel: SignupViewModelType
    
    // MARK: Init
    
    init(viewModel: SignupViewModelType) {
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
        phoneNumberLabel.text = String(localized: "phoneNumberLbl")
        warningPhone.text = String(localized: "Phoneblank")
        navigationController?.navigationBar.isHidden = true
        warningPhone.isHidden = true
        phoneNumberTFView.phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneNumberTFView.heightAnchor.constraint(equalTo: phoneNumberTFView.phoneTextField.heightAnchor).isActive = true
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        bindLabels()
        bindLoginButton()
        bindSignupButton()
       // bindSocialMediaButtons()
        bindViewModel()
        phoneNumberTFView.layer.cornerRadius = 15
        phoneNumberTFView.layer.borderColor = UIColor.border.cgColor
        phoneNumberTFView.clipsToBounds = true
        warningPhone.isHidden = true
        
       /// viewModel.
    }
    
    @objc func textFieldDidChange() {
        // إرجاع لون البوردر للحالة الطبيعية
        phoneNumberTFView.layer.borderColor = UIColor.border.cgColor
//        phoneNumberTFView.layer.borderWidth = 1.0
        warningPhone.isHidden = true
        warningPhone.text = String(localized: "Phoneblank")
    }
}

// MARK: - Actions

extension SignupViewController {
    
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            
            showIncorrectBranchAlert(msg: alertMessage)
           // self.showError("Invalid", "Your phone format is not correct")
//            phoneNumberTFView.layer.borderColor = UIColor.redColor.cgColor
//            phoneNumberTFView.layer.borderWidth = 1.0
//            warningPhone.isHidden = false
//            warningPhone.text = alertMessage
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            
            if result.state {
                
                let vc = VerificationViewController(viewModel: VerificationViewModel(remote: VerficationRemote(network: AlamofireNetwork())))
                vc.phoneNumber = phoneNumberTFView.getFullPhoneNumber()
                vc.viewModel.getOTP(phone: phoneNumberTFView.getFullPhoneNumber())
                vc.register = true
                UserDefaults.standard.set(phoneNumberTFView.countryLabel.text, forKey: "CoutryCode")
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        viewModel.onUpdateLoadingStatus = { [weak self] state in
            
            guard let self = self else { return }
            warningPhone.text = String(localized: "Phoneblank")
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

extension SignupViewController {
    func bindLabels() {
        titleLabel.applyLabelStyle(.screenTitle)
        titleLabel.text = String(localized: "CreateAccount")
        phoneNumberLabel.applyLabelStyle(.textFieldTitleLabel)
        haveAccountLabel.applyLabelStyle(.textFieldTitleLabel)
        haveAccountLabel.text = String(localized: "Alreadyhaveanaccount")
    }
    
    func bindLoginButton() {
        signupButton.setTitle(String(localized: "SignUp"), for: .normal)
        signupButton.applyButtonStyle(.filled)
        signupButton.addTarget(self, action: #selector(signupIsTapped), for: .touchUpInside)
    }
    
    func bindSignupButton() {
        loginButton.applyButtonStyle(.plain)
        loginButton.setTitle(String(localized: "LoginButton"), for: .normal)
        loginButton.addTarget(self, action: #selector(loginIsTapped), for: .touchUpInside)
        
    }
    
//    func bindSocialMediaButtons() {
//        facebookButton.applyButtonStyle(.socialMediaBorder)
//        googleButton.applyButtonStyle(.socialMediaBorder)
//        facebookButton.addTarget(self, action: #selector(facebookIsTapped), for: .touchUpInside)
//        googleButton.addTarget(self, action: #selector(googleIsTapped), for: .touchUpInside)
//    }
    
    
}

// MARK: - Private Handlers

extension SignupViewController {
    
    @objc func loginIsTapped() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signupIsTapped() {
//        let vc = VerificationViewController(viewModel: VerificationViewModel())
//        vc.isForgotPassword = false
//        vc.phoneNumber = phoneNumberTFView.phoneTextField.text ?? ""
//        navigationController?.pushViewController(vc, animated: true)
        let phone = phoneNumberTFView.getFullPhoneNumber()
        if phone.count > 4 {
            viewModel.checkPhoneExist(phone){}
            phoneNumberTFView.layer.borderColor = UIColor.border.cgColor
            warningPhone.text = String(localized: "Phoneblank")
            warningPhone.isHidden = true
            UserDefaults.standard.set(phone, forKey: "phone")
            UserDefaults.standard.set(phoneNumberTFView.countryLabel.text, forKey: "CoutryCode")
        }else {
            //showError("invalid", "phone is required")
            phoneNumberTFView.layer.borderColor = UIColor.redColor.cgColor
            phoneNumberTFView.layer.borderWidth = 1.0
            warningPhone.isHidden = false
        }
    }
    
//    @objc func facebookIsTapped() {
//
//    }
//
//    @objc func googleIsTapped() {
//
//    }
    
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
    
    func showIncorrectBranchAlert(msg: String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show("Invalid!!", "\(msg)", buttonTitle: "Retry", navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
    
    func alertButtonClicked() {
        
    }
}
