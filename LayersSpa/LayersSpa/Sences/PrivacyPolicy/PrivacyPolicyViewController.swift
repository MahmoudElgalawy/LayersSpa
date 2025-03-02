//  
//  PrivacyPolicyViewController.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var desc3Label: UILabel!
    @IBOutlet weak var desc2Label: UILabel!
    @IBOutlet weak var desc1Label: UILabel!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    // MARK: Properties

    private let viewModel: PrivacyPolicyViewModelType

    // MARK: Init

    init(viewModel: PrivacyPolicyViewModelType) {
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
        navBar.updateTitle("Privacy policy")
        navBar.delegate = self
        bindLabels()
    }
}

// MARK: - Actions

extension PrivacyPolicyViewController {}

// MARK: - Configurations

extension PrivacyPolicyViewController {
    func bindLabels() {
        desc1Label.applyLineSpacing("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Lorem ipsum dolor sit amet, consectetur adipng elit, sed do eiusmod tempor incididunt ut labore dolore.\nmagna.Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. ")
        
        desc2Label.applyLineSpacing("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Lorem ipsum dolor sit amet.\nconsectetur adipng elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. ")
        
        desc3Label.applyLineSpacing("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Lorem ipsum dolor sit amet, consectetur adipng elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. ")
    }
}

// MARK: - Private Handlers

private extension PrivacyPolicyViewController {}

extension PrivacyPolicyViewController : RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
