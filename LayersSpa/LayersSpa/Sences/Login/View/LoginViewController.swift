//
//  LoginViewController.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import UIKit
import UILayerSpa

class LoginViewController: UIViewController, CustomAlertDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) weak var signupButton: UIButton!
    @IBOutlet private(set) weak var haveAccountLabel: UILabel!
    @IBOutlet private(set) weak var loginButton: UIButton!
    @IBOutlet private(set) weak var forgetPasswordButton: UIButton!
    @IBOutlet private(set) weak var passwordTF: UITextField!
    @IBOutlet private(set) weak var loginTitleLabel: UILabel!
    @IBOutlet private(set) weak var passwordLabel: UILabel!
    @IBOutlet private(set) weak var phoneNumberTFView: PhoneNumberTextFieldView!
    @IBOutlet private(set) weak var phoneNumberLabel: UILabel!
    @IBOutlet private(set) weak var orLabel: UILabel!
    @IBOutlet private(set) weak var googleLoginButton: UIButton!
    @IBOutlet private(set) weak var facebookLoginButton: UIButton!
    
    @IBOutlet weak var phoneBlankWarning: UILabel!
    @IBOutlet weak var passwordBlank: UILabel!
    
    
    // MARK: Properties
    
    private var viewModel: LoginViewModelType
    
    // MARK: Init
    
    init(viewModel: LoginViewModelType) {
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
        
        if viewModel.isLoggedIn {
            NavigateToCustomTabBar()
            return
        }
        activityIndicator.stopAnimating()
        navigationController?.navigationBar.isHidden = true
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        phoneNumberTFView.phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneNumberTFView.heightAnchor.constraint(equalTo: phoneNumberTFView.phoneTextField.heightAnchor).isActive = true
        phoneNumberTFView.phoneTextField.layer.cornerRadius = 15
        bindLabels()
        bindTextFields()
        bindLoginButton()
        bindSignupButton()
        bindForgetPasswordButton()
       // bindSocialMediaButtons()
        bindViewModel()
        
        phoneNumberTFView.layer.cornerRadius = 15
        phoneNumberTFView.layer.borderColor = UIColor.border.cgColor
        phoneNumberTFView.clipsToBounds = true
        phoneBlankWarning.isHidden = true
        passwordBlank.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        // إرجاع لون البوردر للحالة الطبيعية
        phoneNumberTFView.layer.borderColor = UIColor.border.cgColor
        passwordTF.layer.borderColor = UIColor.border.cgColor
//        phoneNumberTFView.layer.borderWidth = 1.0
        phoneBlankWarning.isHidden = true
        passwordBlank.isHidden = true
        phoneBlankWarning.text = "Phone can not be blank"
    }
}

// MARK: - Actions

extension LoginViewController {
    
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
           // self.showError("Invalid", alertMessage)
//            phoneBlankWarning.isHidden = false
           // phoneBlankWarning.text = "This phone is not exist!"
//            phoneNumberTFView.layer.borderWidth = 1.0
//            phoneNumberTFView.layer.borderColor = UIColor.redColor.cgColor
            showIncorrectBranchAlert(msg: alertMessage)
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            //            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            //            UserDefaults.standard.set(result.token, forKey: "userToken")
            print(result.name, result.phone)
            NavigateToCustomTabBar()
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

extension LoginViewController {
    func bindLabels() {
        loginTitleLabel.applyLabelStyle(.screenTitle)
        phoneNumberLabel.applyLabelStyle(.textFieldTitleLabel)
        passwordLabel.applyLabelStyle(.textFieldTitleLabel)
        haveAccountLabel.applyLabelStyle(.textFieldTitleLabel)
        haveAccountLabel.text = "Don't have an account?"
    }
    
    func bindTextFields() {
        passwordTF.applyBordertextFieldStyle("Enter your password")
        passwordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTF.layer.borderColor = UIColor.border.cgColor
        passwordTF.layer.cornerRadius = 15
        passwordTF.addPasswordToggle()
    }
    
    func bindLoginButton() {
        loginButton.setTitle("Sign in", for: .normal)
        loginButton.applyButtonStyle(.filled)
        loginButton.addTarget(self, action: #selector(loginIsTapped), for: .touchUpInside)
    }
    
    func bindForgetPasswordButton() {
        //  forgetPasswordButton.setTitle("Forgot password?", for: .normal)
        forgetPasswordButton.applyButtonStyle(.plain)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordIsTapped), for: .touchUpInside)
    }
    
    func bindSignupButton() {
        // signupButton.setTitle("Register", for: .normal)
        signupButton.applyButtonStyle(.plain)
        signupButton.addTarget(self, action: #selector(signupIsTapped), for: .touchUpInside)
    }
    
//    func bindSocialMediaButtons() {
//        facebookLoginButton.applyButtonStyle(.socialMediaBorder)
//        googleLoginButton.applyButtonStyle(.socialMediaBorder)
//        facebookLoginButton.addTarget(self, action: #selector(facebookIsTapped), for: .touchUpInside)
//        googleLoginButton.addTarget(self, action: #selector(googleIsTapped), for: .touchUpInside)
//    }
    
}

// MARK: - Private Handlers

 extension LoginViewController {
    @objc func loginIsTapped() {
        let phone = phoneNumberTFView.getFullPhoneNumber()
        guard  phone.count > 4 else{
            phoneBlankWarning.isHidden = false
            phoneNumberTFView.layer.borderWidth = 1.0
            phoneNumberTFView.layer.borderColor = UIColor.redColor.cgColor
          return }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            passwordTF.layer.borderColor = UIColor.red.cgColor
            passwordBlank.isHidden = false
            return
        }
        
        viewModel.userLogin(phoneNumberTFView.getFullPhoneNumber(), password)
        UserDefaults.standard.set(phoneNumberTFView.countryLabel.text, forKey: "CoutryCode")
    }
    
    func NavigateToCustomTabBar() {
        let customTabBarController = CustomTabBarViewController()
        guard let window = UIApplication.shared.windows.first else {
            print("No current window found")
            return
        }
        window.rootViewController = UINavigationController(rootViewController: customTabBarController)
        window.makeKeyAndVisible()
    }
    
    
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
    
    @objc func forgetPasswordIsTapped() {
        let vc = ForgotPasswordViewController(viewModel: ForgotPasswordViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signupIsTapped() {
        let vc = SignupViewController(viewModel: SignupViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc func facebookIsTapped() {
//        
//    }
//    
//    @objc func googleIsTapped() {
//        
//    }
    
    func showIncorrectBranchAlert(msg: String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show("Invalid!!", "\(msg)", buttonTitle: "Retry", navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
    
    func alertButtonClicked() {
        
    }
}

