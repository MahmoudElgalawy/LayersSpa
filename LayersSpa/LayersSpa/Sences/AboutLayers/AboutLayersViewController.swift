//  
//  AboutLayersViewController.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import UIKit

class AboutLayersViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var visionDescLabel: UILabel!
    @IBOutlet weak var valueDescLabel: UILabel!
    @IBOutlet weak var storyDescLabel: UILabel!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    // MARK: Properties

    private let viewModel: AboutLayersViewModelType

    // MARK: Init

    init(viewModel: AboutLayersViewModelType) {
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
        navBar.updateTitle("About Layers")
        navBar.delegate = self
        bindLabels()
    }
}

// MARK: - Actions

extension AboutLayersViewController {}

// MARK: - Configurations

extension AboutLayersViewController {
    func bindLabels() {
        storyDescLabel.applyLineSpacing("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Lorem ipsum dolor sit amet, consectetur adipng elit, sed do eiusmod tempor incididunt ut labore dolore.\nmagna.Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. ")
        
        valueDescLabel.applyLineSpacing("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Lorem ipsum dolor sit amet.\nconsectetur adipng elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. ")
        
        visionDescLabel.applyLineSpacing("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Lorem ipsum dolor sit amet, consectetur adipng elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet, consectetur adcing elit, sed do eiusmod tempor incididunt ut labore dolore magna.Lorem ipsum dolor sit amet.\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. ")
    }
}

// MARK: - Private Handlers

private extension AboutLayersViewController {}

extension AboutLayersViewController : RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
