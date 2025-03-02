//  
//  CreditCardDetailsViewController.swift
//  LayersSpa
//
//  Created by marwa on 05/08/2024.
//

import UIKit
import UILayerSpa

class CreditCardDetailsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    // MARK: Properties

    private let viewModel: CreditCardDetailsViewModelType
    var selectedIndexes: [Int: IndexPath] = [:]
    
    var branches: [BookingSummerySectionsVM] = [
        BookingSummerySectionsVM(sectionIcon: .visamaster, sectionTitle: "Credit Card"),
        BookingSummerySectionsVM(sectionIcon: .pay, sectionTitle: "Apple pay"),
        BookingSummerySectionsVM(sectionIcon: .unSelectedRadioButton, sectionTitle: "My Wallet")
    ]
    
    var creditCard: [BookingSummerySectionsVM] = [
        BookingSummerySectionsVM(sectionIcon: .visa, sectionTitle: "Master Card - 5453"),
        BookingSummerySectionsVM(sectionIcon: .visamaster, sectionTitle: "Master Card - 5453")
    ]
    

    // MARK: Init

    init(viewModel: CreditCardDetailsViewModelType) {
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAddNewButtonPressed),
                                               name: .addNewButtonPressed,
                                               object: nil)
        navBar.delegate = self
        navBar.updateTitle("Recharge")
        tableViewSetup()
        selectFirstRow()
        applyViewStyle()
        bindNextButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Configurations

extension CreditCardDetailsViewController {
    
    @objc func handleAddNewButtonPressed() {
        let vc = AddNewPaymentViewController(viewModel: AddNewPaymentViewModel())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func selectFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        paymentTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        if let cell: PaymentOptionsTableViewCell = paymentTableView.cellForRow(at: indexPath) as? PaymentOptionsTableViewCell {
            cell.selectedStyle()
        }
    }
    
    
    func tableViewSetup() {
        paymentTableView.register(PaymentOptionsTableViewCell.self)
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
    }
    
}


// MARK: - Actions

extension CreditCardDetailsViewController {
    func applyViewStyle() {
        progressStackView.roundCorners(radius: 6)
        progressView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
        paymentTableView.roundCorners(radius: 16)
    }
    
    func bindNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.applyButtonStyle(.filled)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    @objc func nextTapped() {
        let vc = EnterAmountViewController(viewModel: EnterAmountViewModel())
        vc.step = "3"
        vc.navTitle = "Recharge"
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension CreditCardDetailsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = PaymentHeaderView()
        if section == 0 {
            headerView.configureView("Select one of layers branches", false)
        } else {
            headerView.configureView("Choose credit card", true)
            headerView.bindAddNewButton()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndexes[indexPath.section] = indexPath
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension CreditCardDetailsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return branches.count
        }else {
            return creditCard.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentOptionsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        let isSelected = selectedIndexes[indexPath.section] == indexPath
        if isSelected {
            cell.selectedStyle()
        } else {
            cell.unSelectedStyle()
        }
        
        if indexPath.section == 0 {
            cell.configureCell(branches[indexPath.row])
        } else {
            cell.configureCell(creditCard[indexPath.row])
        }
       
        cell.selectionStyle = .none
        
        return cell
    }
    
}



// MARK: - Private Handlers

private extension CreditCardDetailsViewController {}

extension CreditCardDetailsViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
