//  
//  SelectProfessionalMemberViewController.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import UIKit

class SelectProfessionalMemberViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var professionalMemberTableView: UITableView!
    @IBOutlet weak var searchView: SearchWithFilterAndSortView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties

    var viewModel: SelectProfessionalMemberViewModelType
    var selectedProfessional: Employee?
    var completionHandler: ((Employee) -> Void)?
   // var delegate: selectedProfessionalDelegation?
    var isPerService = false
    var index = 0

    // MARK: Init

    init(viewModel: SelectProfessionalMemberViewModelType) {
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
        titleLabel.text = String(localized: "selectProfessional")
        selectedProfessional = nil
        tableViewSetup()
        bindDismissButton()
        bindContinueButton()
        loadSelectedProfessionalFromUserDefaults()

    }
    
    func tableViewSetup() {
        professionalMemberTableView.register(ProfessionalMemberTableViewCell.self)
        professionalMemberTableView.delegate = self
        professionalMemberTableView.dataSource = self
    }
    
    func saveSelectedProfessionalToUserDefaults() {
        guard let selectedProfessional = selectedProfessional else { return }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(selectedProfessional) {
            UserDefaults.standard.set(encodedData, forKey: "selectedProfessional")
        }
    }

    func loadSelectedProfessionalFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "selectedProfessional") {
            let decoder = JSONDecoder()
            if let loadedProfessional = try? decoder.decode(Employee.self, from: savedData) {
                selectedProfessional = loadedProfessional
            }
        }
    }
    
    func bindDismissButton() {
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }
    
    @objc func dismissTapped() {
            self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate

extension SelectProfessionalMemberViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfessionalMemberTableViewCell else {
            return
        }
        cell.selectedStyle()
        selectedProfessional = viewModel.members[indexPath.row]
        index = indexPath.row
        saveSelectedProfessionalToUserDefaults()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfessionalMemberTableViewCell else {
            return
        }
        cell.unSelectedStyle()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension SelectProfessionalMemberViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: ProfessionalMemberTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configeCell(viewModel.members[indexPath.row])
        return cell
    }
    
}



// MARK: - Configurations

extension SelectProfessionalMemberViewController {
    func bindContinueButton() {
        continueButton.setTitle(String(localized: "continue"), for: .normal)
        continueButton.applyButtonStyle(.filled)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc func continueTapped() {
        guard let _ = selectedProfessional, let indexPath = professionalMemberTableView.indexPathForSelectedRow else {
            showNoServicesOrProductAlert(msg: String(localized: "pleaseSelectAProfessionalBeforeContinuing"), btnTitle: String(localized: "selectProfessional"))
               return
           }
           
        completionHandler!(selectedProfessional!)
          // delegate?.selectProfessionalPerService(selectedProfessional)
           
           self.dismiss(animated: true)

    }
    
    func showNoServicesOrProductAlert(msg:String, btnTitle: String) {
        let alertVC = CustomAlertViewController()
        alertVC.show(String(localized: "warning"), msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
        present(alertVC, animated: true, completion: nil)
    }
}

// MARK: - Private Handlers

private extension SelectProfessionalMemberViewController {}

extension SelectProfessionalMemberViewController: SearchWithFilterAndSortViewDelegation {
    func showFilter() {
        print("filter")
    }
    
    func showSort() {
        print("sort")
    }
    
}


