//
//  SignupCompleteViewController.swift
//  LayersSpa
//
//  Created by marwa on 19/07/2024.
//

import UIKit
import UILayerSpa

class SignupCompleteViewController: UIViewController, CustomAlertDelegate {
  
    
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var checkBoxView: CheckBox!
    @IBOutlet weak var msgTextView: UITextView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailAddressTF: UITextField!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var nameTitleTF: UITextField!
    @IBOutlet weak var nameTtleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBar: RegistrationNavigationBar!
    
    @IBOutlet weak var blankName: UILabel!
    @IBOutlet weak var blankEmail: UILabel!
    @IBOutlet weak var blankPassword: UILabel!
    @IBOutlet weak var blankConfirrmPassword: UILabel!
    
    
    
    // MARK: Properties
    
    private var viewModel: SignupCompleteViewModelType
    var phoneNumber = ""
    
    // MARK: Init
    
    init(viewModel: SignupCompleteViewModelType) {
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
        titleLabel.text = String(localized: "Complete")
        nameTtleLabel.text = String(localized: "NameLbl")
        emailAddressLabel.text = String(localized: "Email")
        passwordLabel.text = String(localized: "passwordLbl")
        confirmPasswordLabel.text = String(localized: "Confirm Password")
        confirmButton.setTitle(String(localized: "Confirm"), for: .normal)
        blankName.text = String(localized: "blankName")
        blankEmail.text = String(localized: "blankEmail")
        blankPassword.text = String(localized: "passwordBlank")
        blankConfirrmPassword.text = String(localized: "ConfirmpasswordBlank")
        
        
        blankName.isHidden = true
        blankEmail.isHidden = true
        blankPassword.isHidden = true
        blankConfirrmPassword.isHidden = true
        nameTitleTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailAddressTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTF.layer.borderWidth = 1
        confirmPasswordTF.layer.borderWidth = 1
        nameTitleTF.layer.borderWidth = 1
        emailAddressTF.layer.borderWidth = 1
        
        activityIndicator.stopAnimating()
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        navBar.navDelegate = self
        setupMsgTextView()
        bindLabels()
        bindTextFields()
        bindResetPasswordButton()
        bindViewModel()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

        switch textField {
        case nameTitleTF:
            blankName.isHidden = true
            nameTitleTF.layer.borderColor = UIColor.border.cgColor
        case emailAddressTF:
            blankEmail.isHidden = true
            emailAddressTF.layer.borderColor = UIColor.border.cgColor
        case passwordTF:
            blankPassword.isHidden = true
            passwordTF.layer.borderColor = UIColor.border.cgColor
        case confirmPasswordTF:
            blankConfirrmPassword.text = "the confirm password can not be blank"
            blankConfirrmPassword.isHidden = true
            confirmPasswordTF.layer.borderColor = UIColor.border.cgColor
        default:
            break
        }
    }

}

// MARK: - Actions

extension SignupCompleteViewController {
    
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            self.showError("Invalid", alertMessage)
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            print(result.name, result.phone)
            showAlert()
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
    
    func bindLabels() {
        confirmPasswordLabel.applyLabelStyle(.textFieldTitleLabel)
        titleLabel.applyLabelStyle(.screenTitle)
        passwordLabel.applyLabelStyle(.textFieldTitleLabel)
        nameTtleLabel.applyLabelStyle(.textFieldTitleLabel)
        emailAddressLabel.applyLabelStyle(.textFieldTitleLabel)
    }
    
    func bindTextFields() {
        passwordTF.applyBordertextFieldStyle(String(localized: "passwordTextField"))
        passwordTF.addPasswordToggle()
        confirmPasswordTF.applyBordertextFieldStyle(String(localized: "passwordTextField"))
        confirmPasswordTF.addPasswordToggle()
        nameTitleTF.applyBordertextFieldStyle(String(localized: "EnterName"))
        emailAddressTF.applyBordertextFieldStyle(String(localized: "EnterEmail"))
    }
    
    func bindResetPasswordButton() {
        confirmButton.applyButtonStyle(.filled)
        confirmButton.addTarget(self, action: #selector(confirmIsTapped), for: .touchUpInside)
    }
}

// MARK: - Configurations

extension SignupCompleteViewController {
    func NavigateToCustomTabBar() {
        let customTabBarController = CustomTabBarViewController()
        let navigationController = UINavigationController(rootViewController: customTabBarController)
        guard let window = UIApplication.shared.currentWindow else {
            print("No current window found")
            return
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
    
    func setupMsgTextView() {
        msgTextView.isEditable = false
        msgTextView.isScrollEnabled = false
        msgTextView.dataDetectorTypes = []
        msgTextView.backgroundColor = .clear
        msgTextView.linkTextAttributes = [
            .foregroundColor: UIColor.primary,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        // Create the attributed string with links
        let fullText =  String(localized:"check")
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let linkRange1 = (fullText as NSString).range(of: String(localized:"Terms"))
        let linkRange2 = (fullText as NSString).range(of: String(localized:"Privacy"))
        
        attributedString.addAttribute(.link, value: "action1", range: linkRange1)
        attributedString.addAttribute(.link, value: "action2", range: linkRange2)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        
        let attributes: [NSAttributedString.Key: Any] = [
                    .paragraphStyle: paragraphStyle,
                    .font: UIFont.B3Regular,
                    .foregroundColor: UIColor.darkTextColor
                ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
        msgTextView.attributedText = attributedString
        msgTextView.delegate = self
    }
}

// MARK: - Private Handlers

private extension SignupCompleteViewController {
    
    @objc func confirmIsTapped() {
        
            let isNameValid = validateTextField(nameTitleTF, errorLabel: blankName)
            //let isEmailValid = validateTextField(emailAddressTF, errorLabel: blankEmail)
            let isPasswordValid = validateTextField(passwordTF, errorLabel: blankPassword)
            let isConfirmPasswordValid = validateTextField(confirmPasswordTF, errorLabel: blankConfirrmPassword)
            
            if !(isNameValid  && isPasswordValid && isConfirmPasswordValid) {
                return
            }
//
        if passwordTF.text != confirmPasswordTF.text {
                //showError("Error", "Passwords do not match.")
            confirmPasswordTF.layer.borderColor = UIColor.redColor.cgColor
            blankConfirrmPassword.text =  String(localized:"matchpassword")
            blankConfirrmPassword.isHidden = false
                return
            }
            
           
                viewModel.userSignup(phoneNumber, passwordTF.text ?? "", emailAddressTF.text ?? "", nameTitleTF.text ?? "", "en")
    }
}


extension SignupCompleteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "action1" {
            print("First link tapped")
            // Perform action for the first link
        } else if URL.absoluteString == "action2" {
            print("Second link tapped")
            // Perform action for the second link
        }
        return false
    }
}

extension SignupCompleteViewController: RegistrationNavigationBarDelegate {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func validateTextField(_ textField: UITextField, errorLabel: UILabel) -> Bool {
        if let text = textField.text, text.isEmpty {
            errorLabel.isHidden = false
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
            return false
        }
        
        if textField == passwordTF, let password = textField.text, password.count < 6 {
               errorLabel.isHidden = false
               errorLabel.text = String(localized:"PassNums")
               textField.layer.borderColor = UIColor.red.cgColor
               textField.layer.borderWidth = 1
               return false
           }
        errorLabel.isHidden = true
        textField.layer.borderColor = UIColor.border.cgColor
        return true
    }

    func showAlert() {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show("Congratulations", "Your Account Created Successfully", buttonTitle: "Sign in",navigateButtonTitle: "", .primaryColor, .alertImage, flag: true)
    }
    
    func alertButtonClicked() {
        let vc = LoginViewController(viewModel: LoginViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
