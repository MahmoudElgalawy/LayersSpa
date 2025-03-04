//  
//  VerificationViewController.swift
//  LayersSpa
//
//  Created by marwa on 17/07/2024.
//

import UIKit
import UILayerSpa

class VerificationViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var receiveCodeLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var otpTF: OTCTextField!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navBar: RegistrationNavigationBar!
    
    
    // MARK: Properties
    var phoneNumber = ""
    var viewModel: VerificationViewModelType
    var isForgotPassword: Bool = true
    private var countdownTimer: Timer?
    private var remainingTime = 40
    var register = false

    // MARK: Init

    init(viewModel: VerificationViewModelType) {
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
    
        titleLabel.text = String(localized: "PhoneVerification")
        subtitleLabel.text = String(localized: "verificationsent")
        resendCodeButton.isHidden = true
        receiveCodeLabel.isHidden = true
        //startCountdown()
        self.view.setGradientBackground(startColor: .primaryColor, endColor: .whiteColor)
        phoneNumberLabel.text = UserDefaults.standard.string(forKey: "phone")
        navBar.navDelegate = self
        bindLabels()
        bindConfirmButton()
        bindResendCodeButton()
        otpTF.configure()
        otpTF.didEnterLastDigit = { [weak self] code in
            guard let self = self else {return}
            print(code)
        }
    }
}

// MARK: - Actions

extension VerificationViewController {}

// MARK: - Configurations

extension VerificationViewController {
    
    func bindLabels() {
        titleLabel.applyLabelStyle(.screenTitle)
        subtitleLabel.applyLabelStyle(.subtitleLabel)
        phoneNumberLabel.applyLabelStyle(.coloredSubtitle)
        receiveCodeLabel.applyLabelStyle(.textFieldTitleLabel)
    }
    
    func bindConfirmButton() {
        confirmButton.applyButtonStyle(.filled)
        confirmButton.setTitle(String(localized: "Confirm"), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmIsTapped), for: .touchUpInside)
    }
    
    func bindResendCodeButton() {
        resendCodeButton.applyButtonStyle(.plain)
        resendCodeButton.isEnabled = false // تعطيل الزر عند بدء الشاشة
        resendCodeButton.addTarget(self, action: #selector(resendCodeIsTapped), for: .touchUpInside)
    }
}

// MARK: - Private Handlers

private extension VerificationViewController {
    @objc func confirmIsTapped() {
            
//            resendCodeButton.isEnabled = false
//            startCountdown()
        
                guard let otpText = otpTF.text, !otpText.isEmpty else {
                      //  let alert = CustomAlertViewController()
                    //alert.show("Invalid", "Enter the code which send to your phone", buttonTitle: "Try Again",.redColor,.warning)
                    showIncorrectBranchAlert(title:String(localized: "Invalid"), msg: String(localized: "errormsg"), btn: String(localized: "Retry"))
                        return
                    }
        print("Confirm button tapped")
        if register{
            if let otp = otpTF.text {
                UserDefaults.standard.set(otp, forKey: "otp")
                viewModel.checkOTP(phone: phoneNumber, otp: Int(otp) ?? 0) { [weak self] flag in
                    if flag {
                        let vc = SignupCompleteViewController(viewModel: SignupCompleteViewModel())
                        vc.phoneNumber = self?.phoneNumber ?? ""
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else{
                       // let alert = CustomAlertViewController()
                      //  alert.show("Invalid", "Code or phone not correct", buttonTitle: "Try Again",.redColor,.warning)
                        self?.showIncorrectBranchAlert(title:String(localized: "Invalid"), msg: String(localized:"otpNotCorrect"), btn: String(localized: "Retry"))
                    }
                }
            }else{
              //  let alert = CustomAlertViewController()
                showIncorrectBranchAlert(title:String(localized: "Invalid"), msg: String(localized: "errormsg"), btn: String(localized: "Retry"))
            }
        }else{
//
            
            if let otp = otpTF.text {
                UserDefaults.standard.set(otp, forKey: "otp")
                viewModel.checkOTP(phone: phoneNumber, otp: Int(otp) ?? 0) { [weak self] flag in
                    if flag {
                        let vc = NewPasswordViewController(viewModel: ForgotPasswordViewModel())
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }else{
                       // let alert = CustomAlertViewController()
                      //  alert.show("Invalid", "Code or phone not correct", buttonTitle: "Try Again",.redColor,.warning)
                        self?.showIncorrectBranchAlert(title:String(localized: "Invalid"), msg:  String(localized:"otpNotCorrect"), btn: String(localized: "Retry"))
                    }
                }
            }else{
              //  let alert = CustomAlertViewController()
                showIncorrectBranchAlert(title:String(localized: "Invalid"), msg: String(localized: "errormsg"), btn: String(localized: "Retry"))
            }
        }
           }
    
    
    @objc func resendCodeIsTapped() {
        
//        guard let otpText = otpTF.text, !otpText.isEmpty else {
//                let alert = CustomAlertViewController()
//            alert.show("Invalid", "Enter the code which send to your phone", buttonTitle: "Try Again",.red,.warning)
//                return
//            }
//
//        if register{
//            if let otp = otpTF.text {
//                viewModel.checkOTP(phone: phoneNumber, otp: Int(otp) ?? 0) { [weak self] flag in
//                    if flag {
//                        let vc = SignupCompleteViewController(viewModel: SignupCompleteViewModel())
//                        vc.phoneNumber = self?.phoneNumber ?? ""
//                        self?.navigationController?.pushViewController(vc, animated: true)
//                    }else{
//                        let alert = CustomAlertViewController()
//                        alert.show("Invalid", "Enter the code which send to your phone", buttonTitle: "Try Again",.red,.warning)
//                    }
//                }
//            }
//         }
        //else{
//            remainingTime = 40
//                resendCodeButton.isEnabled = false
//                startCountdown()
//            viewModel.updatePassword(phone: UserDefaults.standard.string(forKey: "phone") ?? "",
//                                      password: UserDefaults.standard.string(forKey: "password") ?? "",
//                                      otp: otpTF.text ?? "",
//                                      completion: { success, message in
//                                          if success {
//                                              // تنفيذ الكود عند النجاح
//                                              print(message)  // يمكن عرض رسالة النجاح في Alert
//                                              let alert = CustomAlertViewController()
//                                              alert.alertDelegate = self
//                                              alert.show("Password Reset Successfully", message, buttonTitle: "Sign in")
//                                          } else {
//                                              // تنفيذ الكود عند الفشل
//                                              print("Failure: \(message)")  // يمكن عرض رسالة الخطأ في Alert
//                                              let alert = CustomAlertViewController()
//                                              alert.show("Failure", message, buttonTitle: "Try Again")
//                                          }
//                                      })
//            }
        }
    }

    



extension VerificationViewController: RegistrationNavigationBarDelegate {
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension VerificationViewController: CustomAlertDelegate {
    func alertButtonClicked() {
        
    }
}

extension VerificationViewController {

    private func startCountdown() {
        resendCodeButton.isEnabled = false
        updateResendButtonTitle() 
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCountdown() {
        if remainingTime > 0 {
                remainingTime -= 1
                updateResendButtonTitle()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                resendCodeButton.isEnabled = true
                resendCodeButton.setTitle("Resend Code", for: .normal)
            }
    }
    
    private func updateResendButtonTitle() {
        resendCodeButton.setTitle("Resend Code (\(String(format: "%02d", remainingTime)))", for: .disabled)
    }
    
    func showIncorrectBranchAlert(title: String, msg: String, btn: String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(title, "\(msg)", buttonTitle: btn, navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
}


    
   

