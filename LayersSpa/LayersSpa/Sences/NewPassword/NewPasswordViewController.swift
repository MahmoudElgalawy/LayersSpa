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
    // MARK: Properties

    private let viewModel: ForgotPasswordViewModel

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
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        navBar.navDelegate = self
        bindLabels()
        bindTextFields()
        bindResetPasswordButton()
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
        passwordTF.applyBordertextFieldStyle("Enter your password")
        passwordTF.addPasswordToggle()
        confirmPasswordTF.applyBordertextFieldStyle("Enter your password")
        confirmPasswordTF.addPasswordToggle()
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
            showError("Invalid Password", "Password field cannot be empty.")
            return
        }

        guard let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
            showError("Invalid Password", "Confirm Password field cannot be empty.")
            return
        }

        guard password == confirmPassword else {
            showError("Password Mismatch", "Password and Confirm Password do not match.")
            return
        }

        guard password.count >= 6 else {
            showError("Weak Password", "Password must be at least 6 characters long.")
            return
        }

        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil

        guard hasUppercase, hasLowercase else {
            showError("Weak Password", "Password must contain at least one uppercase and one lowercase letter.")
            return
        }

        // تنفيذ طلب تغيير كلمة المرور بعد التحقق من جميع الشروط
        viewModel.resetPassword(UserDefaults.standard.string(forKey: "phone") ?? "")
        UserDefaults.standard.set(passwordTF.text, forKey: "password")
        
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show("Successful Step ", "The Verification Code Was Sent To Your Email", buttonTitle: "Write The Verification Code",navigateButtonTitle: "",.primaryColor,.alertImage, flag: true)
    }

}

extension NewPasswordViewController: RegistrationNavigationBarDelegate {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewPasswordViewController: CustomAlertDelegate {
    func alertButtonClicked() {
        let vc = VerificationViewController(viewModel: VerificationViewModel(remote: VerficationRemote(network: AlamofireNetwork())))
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
}
