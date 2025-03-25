//  
//  NewPasswordViewController.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import UIKit
import UILayerSpa
import Networking

class NewPasswordViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBar: RegistrationNavigationBar!
    @IBOutlet weak var blankPassword: UILabel!
    @IBOutlet weak var blankconfirmPassword: UILabel!
    
    
    // MARK: Properties
    
    private let viewModel: ForgotPasswordViewModel
    var viewModel2 = VerificationViewModel(remote: VerficationRemote(network: AlamofireNetwork()))
    
    // MARK: Init
    
    init(viewModel: ForgotPasswordViewModel) {
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
        titleLabel.text = String(localized: "NewPassword")
        subTitleLabel.text = String(localized: "newPasswordTitle")
        passwordLabel.text = String(localized: "passwordLbl")
        confirmPasswordLabel.text = String(localized: "Confirm Password")
        resetPasswordButton.setTitle(String(localized: "ForgotTitle"), for: .normal)
        blankPassword.text = String(localized: "passwordBlank")
        blankconfirmPassword.text = String(localized: "ConfirmpasswordBlank")
        blankPassword.isHidden = true
        blankconfirmPassword.isHidden = true
        
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        navBar.navDelegate = self
        bindLabels()
        bindTextFields()
        bindResetPasswordButton()
    }
    
    @objc func textFieldDidChange() {
        blankPassword.isHidden = true
        blankPassword.isHidden = true
        blankconfirmPassword.isHidden = true
        passwordTF.layer.borderColor = UIColor.border.cgColor
        confirmPasswordTF.layer.borderColor = UIColor.border.cgColor
    }
}

// MARK: - Actions

extension NewPasswordViewController {}

// MARK: - Configurations

extension NewPasswordViewController {
    func bindLabels() {
        confirmPasswordLabel.applyLabelStyle(.textFieldTitleLabel)
        titleLabel.applyLabelStyle(.screenTitle)
        subTitleLabel.applyLabelStyle(.subtitleLabel)
        passwordLabel.applyLabelStyle(.textFieldTitleLabel)
    }
    
    func bindTextFields() {
        passwordTF.applyBordertextFieldStyle(String(localized: "passwordTextField"))
        passwordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTF.addPasswordToggle()
        confirmPasswordTF.applyBordertextFieldStyle(String(localized: "passwordTextField"))
        confirmPasswordTF.addPasswordToggle()
        confirmPasswordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func bindResetPasswordButton() {
        resetPasswordButton.applyButtonStyle(.filled)
        resetPasswordButton.addTarget(self, action: #selector(resetPasswordIsTapped), for: .touchUpInside)
    }
}

// MARK: - Private Handlers

private extension NewPasswordViewController {
    //    @objc func resetPasswordIsTapped() {
    //            guard let password = passwordTF.text, !password.isEmpty else {
    //                showError("Invalid Password", "Password field cannot be empty.")
    //                return
    //            }
    //
    //            guard let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
    //                showError("Invalid Password", "Confirm Password field cannot be empty.")
    //                return
    //            }
    //
    //            guard password == confirmPassword else {
    //                showError("Password Mismatch", "Password and Confirm Password do not match.")
    //                return
    //            }
    //
    //            viewModel.resetPassword( UserDefaults.standard.string(forKey: "userEmail") ?? "")
    //            UserDefaults.standard.set(passwordTF.text, forKey: "password")
    //            let alert = CustomAlertViewController()
    //            alert.alertDelegate = self
    ////            alert.show("Password Reset Successfully", "Your password has been reset. You can now sign in with your new password.", buttonTitle: "Sign in")
    //            alert.show("Successful Step ✔️", "The Verfication Code It Was Sent To Your Email", buttonTitle: "Write The Verfication Code")
    //        }
    
    @objc func resetPasswordIsTapped() {
        guard let password = passwordTF.text, !password.isEmpty else {
            blankPassword.isHidden = false
            passwordTF.layer.borderColor = UIColor.red.cgColor
            passwordTF.layer.borderWidth = 1
            return
        }
        
        guard let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            blankconfirmPassword.isHidden = false
            confirmPasswordTF.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTF.layer.borderWidth = 1
            return
        }
        
        guard password == confirmPassword else {
            blankconfirmPassword.text = String(localized:"matchpassword")
            confirmPasswordTF.layer.borderColor = UIColor.red.cgColor
            confirmPasswordTF.layer.borderWidth = 1
//            passwordTF.layer.borderColor = UIColor.red.cgColor
//            passwordTF.layer.borderWidth = 1
            blankconfirmPassword.isHidden = false
            return
        }
        
        guard password.count >= 6 else {
            blankPassword.isHidden = false
            passwordTF.layer.borderColor = UIColor.red.cgColor
            passwordTF.layer.borderWidth = 1
            blankPassword.text = String(localized:"PassNums")
            return
        }
        
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        
        guard hasUppercase, hasLowercase else {
            blankPassword.isHidden = false
            passwordTF.layer.borderColor = UIColor.red.cgColor
            passwordTF.layer.borderWidth = 1
            blankPassword.text = String(localized:"passContain")
            return
        }
        
        viewModel2.updatePassword(phone: UserDefaults.standard.string(forKey: "phone") ?? "",
                                  password: passwordTF.text ?? "",
                                  otp: UserDefaults.standard.string(forKey: "otp") ?? "",
                                  completion: { success, message in
            if success {
                
                print(message)
                let alert = CustomAlertViewController()
                alert.alertDelegate = self
                alert.show(String(localized:"resetPassSuccess"), message, buttonTitle:  String(localized:"LoginButton"), navigateButtonTitle: "",.primaryColor,.alertImage, flag: true)
                
            } else {
                
                print("Failure: \(message)")
                self.showIncorrectBranchAlert(title: String(localized:"Invalid"), msg: message, btn: String(localized:"Retry"))
            }
        })
    }
    
}


extension NewPasswordViewController: RegistrationNavigationBarDelegate {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewPasswordViewController: CustomAlertDelegate {
    func alertButtonClicked() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showIncorrectBranchAlert(title: String, msg: String, btn: String) {
        let alert = CustomAlertViewController()
        //alert.alertDelegate = self
        alert.show(title, "\(msg)", buttonTitle: btn, navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
}
