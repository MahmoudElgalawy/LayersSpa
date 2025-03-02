//  
//  RechargeViewController.swift
//  LayersSpa
//
//  Created by 2B on 05/08/2024.
//

import UIKit

class RechargeViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var navBar: NavigationBarWithBack!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var rechargeTableView: UITableView!
    
    // MARK: Properties

    private let viewModel: RechargeViewModelType
    
    var rechargeOptions: [BookingSummerySectionsVM] = [
        BookingSummerySectionsVM(sectionIcon: .payment, sectionTitle: "Credit card"),
        BookingSummerySectionsVM(sectionIcon: .payment, sectionTitle: "Bank account")
    ]

    
    // MARK: Init

    init(viewModel: RechargeViewModelType) {
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
        tableViewSetup()
        applyViewStyle()
        navBar.delegate = self
        navBar.updateTitle("Recharge")
    }
    
    func applyViewStyle() {
        progressStackView.roundCorners(radius: 6)
        progressView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
    }
    
    func tableViewSetup() {
        rechargeTableView.register(SelectProfessionalOptionsTableViewCell.self)
        rechargeTableView.delegate = self
        rechargeTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension RechargeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            let vc = CreditCardDetailsViewController(viewModel: CreditCardDetailsViewModel())
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = WithdrawViewController(viewModel: WithdrawViewModel())
            vc.step = 2
            vc.navTitle = "Recharge"
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("invalid")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension RechargeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rechargeOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: SelectProfessionalOptionsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureCellForRecharge(rechargeOptions[indexPath.row])
        return cell
    }
    
}


// MARK: - Private Handlers

private extension RechargeViewController {}

extension RechargeViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
