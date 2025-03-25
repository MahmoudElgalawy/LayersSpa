//
//  LoginViewController.swift
//  LayersSpa
//
//  Created by marwa on 14/07/2024.
//

import UIKit
import UILayerSpa
import Networking

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
    
    @IBOutlet weak var guestButton: UIButton!
    
    
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
        loginTitleLabel.text = String(localized: "LoginButton")
        phoneBlankWarning.text = String(localized: "Phoneblank")
        passwordBlank.text = String(localized: "passwordBlank")
        if viewModel.isLoggedIn {
            NavigateToCustomTabBar()
            return
        }
        activityIndicator.stopAnimating()
        navigationController?.navigationBar.isHidden = true
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        phoneNumberTFView.phoneTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        phoneNumberTFView.heightAnchor.constraint(equalTo: phoneNumberTFView.phoneTextField.heightAnchor).isActive = true
      //  phoneNumberTFView.phoneTextField.layer.cornerRadius = 15
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
        phoneBlankWarning.text = String(localized: "Phoneblank")
    }
    
    
    @IBAction func guestButtonTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "guest")
        clearStoredData()
        let customTabBarController = CustomTabBarViewController()
        self.navigationController?.pushViewController(customTabBarController, animated: true)
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
            UserDefaults.standard.set(false, forKey: "guest")
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
        phoneNumberLabel.text = String(localized: "phoneNumberLbl")
        passwordLabel.applyLabelStyle(.textFieldTitleLabel)
        passwordLabel.text = String(localized: "passwordLbl")
        haveAccountLabel.applyLabelStyle(.textFieldTitleLabel)
        haveAccountLabel.text = String(localized:"donothaveaccount")
    }
    
    func bindTextFields() {
        passwordTF.applyBordertextFieldStyle(String(localized: "passwordTextField"))
        passwordTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordTF.layer.borderColor = UIColor.border.cgColor
        passwordTF.layer.cornerRadius = 15
        passwordTF.addPasswordToggle()
    }
    
    func bindLoginButton() {
        //loginButton.setTitle("Sign in", for: .normal)
        loginButton.applyButtonStyle(.filled)
        guestButton.applyButtonStyle(.plain)
        loginButton.addTarget(self, action: #selector(loginIsTapped), for: .touchUpInside)
        loginButton.setTitle(String(localized: "LoginButton"), for: .normal)
        guestButton.setTitle(String(localized: "guestLogin"), for: .normal)
        forgetPasswordButton.setTitle(String(localized: "forgetPass"), for: .normal)
    }
    
    func bindForgetPasswordButton() {
        //  forgetPasswordButton.setTitle("Forgot password?", for: .normal)
        forgetPasswordButton.applyButtonStyle(.plain)
        forgetPasswordButton.addTarget(self, action: #selector(forgetPasswordIsTapped), for: .touchUpInside)
        var config = UIButton.Configuration.plain()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var newAttributes = attributes
            newAttributes.font = UIFont.systemFont(ofSize: 12)
            return newAttributes
        }
        forgetPasswordButton.configuration = config
    }
    
    func bindSignupButton() {
        var config = UIButton.Configuration.plain()
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var newAttributes = attributes
            newAttributes.font = UIFont.systemFont(ofSize: 14)
            return newAttributes
        }
        signupButton.configuration = config
        signupButton.applyButtonStyle(.plain)
        signupButton.addTarget(self, action: #selector(signupIsTapped), for: .touchUpInside)
        signupButton.setTitle(String(localized: "Register"), for: .normal)
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
        vc.update = false
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
        alert.show(String(localized:"Invalid"), "\(msg)", buttonTitle:String(localized:"Retry"), navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
    
    func alertButtonClicked() {
        
    }
     
     private func clearStoredData() {
         let defaults = UserDefaults.standard
         defaults.removeObject(forKey: "selectedEmployeeIds")
         defaults.removeObject(forKey: "selectedServiceTime")
         Defaults.sharedInstance.userData = nil
         LocalDataManager.sharedInstance.deleteAllData(.cart)
     }
}
