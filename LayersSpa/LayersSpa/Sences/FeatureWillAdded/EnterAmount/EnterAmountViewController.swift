//  
//  EnterAmountViewController.swift
//  LayersSpa
//
//  Created by marwa on 05/08/2024.
//

import UIKit
import UILayerSpa

class EnterAmountViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: Properties
    
    var navTitle = ""
    var step = "1"

    private let viewModel: EnterAmountViewModelType

    // MARK: Init

    init(viewModel: EnterAmountViewModelType) {
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
        stepLabel.text = step
        applyViewStyle()
        bindConfirmButton()
    }
}

// MARK: - Actions

extension EnterAmountViewController {}

// MARK: - Configurations

extension EnterAmountViewController {
    func applyViewStyle() {
        progressStackView.roundCorners(radius: 6)
        progressView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
        containerView.roundCorners(radius: 16)
    }
    
    func bindConfirmButton() {
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.applyButtonStyle(.filled)
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }
    
    @objc func confirmTapped() {
       
    }
}

// MARK: - Private Handlers

private extension EnterAmountViewController {}

extension EnterAmountViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
