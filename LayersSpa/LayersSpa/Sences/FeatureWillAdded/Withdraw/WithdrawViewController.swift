//  
//  WithdrawViewController.swift
//  LayersSpa
//
//  Created by 2B on 05/08/2024.
//

import UIKit
import UILayerSpa

class WithdrawViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    
    @IBOutlet weak var bankNameTF: UITextField!
    @IBOutlet weak var bankNameLabel: UILabel!
    
    @IBOutlet weak var accountHolderTF: UITextField!
    @IBOutlet weak var accountHolderLabel: UILabel!
    
    @IBOutlet weak var accountNumberTF: UITextField!
    @IBOutlet weak var accountNumberLabel: UILabel!

    @IBOutlet weak var ibanTF: UITextField!
    @IBOutlet weak var ibanLabel: UILabel!
    
    // MARK: Properties
    
    private let viewModel: WithdrawViewModelType
    var step = 1
    var navTitle = "Withdraw"

    // MARK: Init

    init(viewModel: WithdrawViewModelType) {
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
        navBar.delegate = self
        navBar.updateTitle(navTitle)
        applyViewStyle()
        bindNextButton()
        bindLabels()
        bindTextFields()
    }
}

// MARK: - Actions

extension WithdrawViewController {}

// MARK: - Configurations

extension WithdrawViewController {
    func applyViewStyle() {
        stepLabel.text = "\(step)"
        progressStackView.roundCorners(radius: 6)
        progressView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
        containerView.roundCorners(radius: 16)
    }
    
    func bindTextFields() {
        bankNameTF.applyBordertextFieldStyle("Enter bank name")
        accountHolderTF.applyBordertextFieldStyle("Enter account holder")
        accountNumberTF.applyBordertextFieldStyle("Enter account number")
        ibanTF.applyBordertextFieldStyle("Enter IBAN")
    }
    
    func bindLabels() {
        bankNameLabel.applyLabelStyle(.textFieldTitleLabel)
        accountHolderLabel.applyLabelStyle(.textFieldTitleLabel)
        accountNumberLabel.applyLabelStyle(.textFieldTitleLabel)
        ibanLabel.applyLabelStyle(.textFieldTitleLabel)
    }
    
    
    func bindNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.applyButtonStyle(.filled)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    @objc func nextTapped() {
        let vc = EnterAmountViewController(viewModel: EnterAmountViewModel())
        vc.navTitle = navTitle
        vc.step = "\(step + 1)"
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Private Handlers

private extension WithdrawViewController {}

extension WithdrawViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
