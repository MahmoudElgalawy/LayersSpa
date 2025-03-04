//  
//  AddNewPaymentViewController.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import UIKit
import UILayerSpa

class AddNewPaymentViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var addCardButton: UIButton!
    @IBOutlet private weak var cvvTF: UITextField!
    @IBOutlet private weak var cvvLabel: UILabel!
    @IBOutlet private weak var cardNumberTF: UITextField!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var cardHolderNameTF: UITextField!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var hardHoldeNameLabel: UILabel!
    
    @IBOutlet weak var Year: UITextField!
    @IBOutlet weak var Month: UITextField!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    // MARK: Properties

    private let viewModel: AddNewPaymentViewModelType
    var cost = 0.0
    var orderID = 0
    var success = true
    // MARK: Init

    init(viewModel: AddNewPaymentViewModelType) {
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
        titleLabel.text = String(localized: "completePayment")
        hardHoldeNameLabel.text = String(localized: "cardHolderName")
        cardNumberLabel.text = String(localized: "cardNumber")
        yearLabel.text = String(localized: "year")
        monthLabel.text = String(localized: "month")
        bindTextFields()
        bindAddCardButton()
        bindCloseButton()
        containerView.roundCorners(radius: 16)
        cardNumberTF.delegate = self
    }
}

// MARK: - Actions

extension AddNewPaymentViewController {}

// MARK: - Configurations

extension AddNewPaymentViewController {
    
    func bindTextFields() {
        cardHolderNameTF.applyBordertextFieldStyle(String(localized: "enterCardHolderName"))
        cardNumberTF.applyBordertextFieldStyle(String(localized: "enterCardNumber"))
        cvvTF.applyBordertextFieldStyle(String(localized: "enter3DigitsCvvNumber"))
        Year.applyBordertextFieldStyle(String(localized: "expireYear"))
        Month.applyBordertextFieldStyle(String(localized: "expireMonth"))
    }
    
    func bindAddCardButton() {
        addCardButton.setTitle(String(localized: "addCard"), for: .normal)
        addCardButton.applyButtonStyle(.filled)
        addCardButton.addTarget(self, action: #selector(addCardTapped), for: .touchUpInside)
    }
    
    func bindCloseButton() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
}

// MARK: - Private Handlers

private extension AddNewPaymentViewController {
    @objc func addCardTapped() {
        guard
            let cardHolderName = cardHolderNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), !cardHolderName.isEmpty,
            let cardNumber = cardNumberTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), !cardNumber.isEmpty,
            let cvv = cvvTF.text?.trimmingCharacters(in: .whitespacesAndNewlines), !cvv.isEmpty, isValidCVV(cvv),
            let year = Year.text?.trimmingCharacters(in: .whitespacesAndNewlines), !year.isEmpty,
            let month = Month.text?.trimmingCharacters(in: .whitespacesAndNewlines), !month.isEmpty
        else {
            self.success = false
            showAlert(title: String(localized: "warning") + "!!" , msg: String(localized: "allDataRequired"), btnTitle: String(localized: "ok"))
            return
        }
        
        saveCardToUserDefaults(cardHolder: cardHolderName, cardNumber: cardNumber, cvv: cvv, month: month, year: year)

        
        NotificationCenter.default.post(name: .addCardPressed, object: nil)
        self.dismiss(animated: true)
        
        
//        viewModel.PaymentConfirmation(name: cardHolderNameTF.text ?? "", visaNumber: cardNumberTF.text ?? "", month: Month.text ?? "", year: Year.text ?? "", cvc: cvvTF.text ?? "", total: "\(cost)", customerId: "\((Defaults.sharedInstance.userData?.userId)!)", ecommOrderId: "\(orderID)") {[weak self] success in
//            if success {
//                self?.success = true
//                self?.showDismissAlert(message: "Your Order has been successfully paid",title:"Done✔️",actionBtn: "Ok")
//                self?.clearStoredData()
//            }else{
//                self?.success = false
//                self?.showAlert(title:"Warning!!" ,msg:"Some Thing Went Wrong,Please Check Your Card Data And Try Again", btnTitle: "Ok")
//            }
//        }
    }
    
    @objc func closeTapped() {
//        //showAlert(title:"ًًWarning!!" ,msg:"Are You Sure You Don't Want Pay By Visa?", btnTitle: "Ok")
//        showDismissAlert(message: "Are You Sure You Don't Want Pay By Visa?",title: "Warning!!",actionBtn: "Yes")
        self.dismiss(animated: true)
        
    }
    
    private func PaymentConfirmation() {
       
    }
    
    private func isValidCVV(_ cvv: String) -> Bool {
        let cvvRegex = "^[0-9]{3}$" // يتحقق أن الـ CVV مكون من 3 أرقام فقط
        let predicate = NSPredicate(format: "SELF MATCHES %@", cvvRegex)
        return predicate.evaluate(with: cvv)
    }
    
    
    func showAlert(title:String ,msg:String, btnTitle: String) {
            let alertVC = CustomAlertViewController()
        alertVC.show("\(title)", msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
            alertVC.alertDelegate = self
            present(alertVC, animated: true, completion: nil)
    }
}


extension AddNewPaymentViewController: CustomAlertDelegate {
    
    func alertButtonClicked() {
        if success{
            Defaults.sharedInstance.navigateToAppoinment(true)
            let customTabBarController = CustomTabBarViewController()
            let navigationController = UINavigationController(rootViewController: customTabBarController)
            guard let window = UIApplication.shared.currentWindow else {
                print("No current window found")
                return
            }
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }else{
            
               
            
        }
    }
    
    private func showDismissAlert(message: String,title: String,actionBtn:String) {
        let alert = UIAlertController(title: "\(title)", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "\(actionBtn)", style: .default,handler: {[weak self] action in
            self?.clearStoredData()
            Defaults.sharedInstance.navigateToAppoinment(true)
            let customTabBarController = CustomTabBarViewController()
            let navigationController = UINavigationController(rootViewController: customTabBarController)
            guard let window = UIApplication.shared.currentWindow else {
                print("No current window found")
                return
            }
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            self?.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    private func clearStoredData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedEmployeeIds")
        defaults.removeObject(forKey: "selectedServiceTime")
        defaults.synchronize()
    }
    
    
    func saveCardToUserDefaults(cardHolder: String, cardNumber: String, cvv: String, month: String, year: String) {
        let cleanedCardNumber = cardNumber.replacingOccurrences(of: "-", with: "")
        
        let cardData: [String: String] = [
            "cardHolder": cardHolder,
            "cardNumber": cleanedCardNumber,
            "cvv": cvv,
            "month": month,
            "year": year
        ]
        
        var savedCards = UserDefaults.standard.array(forKey: "savedCreditCards") as? [[String: String]] ?? []
        savedCards.append(cardData)
        
        UserDefaults.standard.set(savedCards, forKey: "savedCreditCards")
        UserDefaults.standard.synchronize()
    }

}



extension AddNewPaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == cardNumberTF else { return true }

        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // إزالة أي فواصل قديمة
        let cleanedText = newText.replacingOccurrences(of: "-", with: "")

        // السماح فقط بالأرقام وعدم تجاوز 16 رقمًا
        let formattedText = formatCardNumber(cleanedText)

        // تحديث النص في الحقل
        textField.text = formattedText

        // منع التغيير الافتراضي لأننا نحدث النص يدويًا
        return false
    }
    
    private func formatCardNumber(_ number: String) -> String {
        let trimmedNumber = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var formattedNumber = ""

        for (index, character) in trimmedNumber.enumerated() {
            if index > 0 && index % 4 == 0 {
                formattedNumber.append("-")
            }
            formattedNumber.append(character)
        }

        return formattedNumber
    }
}
