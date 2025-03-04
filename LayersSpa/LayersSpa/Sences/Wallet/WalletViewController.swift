//  
//  WalletViewController.swift
//  LayersSpa
//
//  Created by 2B on 05/08/2024.
//

import UIKit
import UILayerSpa

class WalletViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var rechargeButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var cardBalanceLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var yourBalanceLabel: UILabel!
    // MARK: Properties

    private let viewModel: WalletViewModelType

    // MARK: Init

    init(viewModel: WalletViewModelType) {
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
        indicator.startAnimating()
        navBar.delegate = self
        navBar.updateTitle(String(localized: "wallet"))
        yourBalanceLabel.text = String(localized: "yourBalance")
        withdrawButton.setTitle(String(localized: "withdraw"), for: .normal)
        rechargeButton.setTitle(String(localized: "recharge"), for: .normal)
        applyViewStyle()
        bindRechargeButton()
        bindWithdrawButton()
        tableViewSetup()
        updateTableViewHeightConstraints()
        transactionsTableView.isHidden = true
        withdrawButton.isHidden = true
        rechargeButton.isHidden = true
        
        viewModel.getCustomerBalance { balance in
            DispatchQueue.main.async { [weak self] in
                self?.indicator.stopAnimating()
                self?.cardBalanceLabel.text = "\(balance)"
            }
        }
    }
}

// MARK: - Actions

extension WalletViewController {}

// MARK: - Configurations

extension WalletViewController {
    func applyViewStyle() {
        cardView.roundCorners(radius: 24)
    }
    
    func bindWithdrawButton() {
        withdrawButton.roundCorners(radius: 16)
        withdrawButton.titleLabel?.font = .B3Medium
        withdrawButton.applyImagePaddingConfiguration(20)
        withdrawButton.addTarget(self, action: #selector(withdrawTapped), for: .touchUpInside)
    }
    
    func bindRechargeButton() {
        rechargeButton.roundCorners(radius: 16)
        rechargeButton.titleLabel?.font = .B3Medium
        rechargeButton.applyImagePaddingConfiguration(20)
        rechargeButton.addTarget(self, action: #selector(rechargeTapped), for: .touchUpInside)
    }
}

extension WalletViewController {

    func tableViewSetup() {
        transactionsTableView.register(TransactionsTableViewCell.self)
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
    }
    
   func updateTableViewHeightConstraints() {
       tableViewHeight.constant = 4 * 88 + 60
    }
}

// MARK: - UITableViewDelegate

extension WalletViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TransactionsHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension WalletViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: TransactionsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
      //  cell.configeCell(notifications[indexPath.row])
        return cell
    }
    
}



// MARK: - Private Handlers

private extension WalletViewController {
    @objc func withdrawTapped() {
        let vc = WithdrawViewController(viewModel: WithdrawViewModel())
        navigationController?.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
    
    @objc func rechargeTapped() {
        let vc = RechargeViewController(viewModel: RechargeViewModel())
        navigationController?.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
}

extension WalletViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
