//  
//  SettingViewController.swift
//  LayersSpa
//
//  Created by marwa on 09/08/2024.
//

import UIKit

class SettingViewController: UIViewController, CustomAlertDelegate, AddToCartAlerts {
   
    // MARK: Outlets

    @IBOutlet weak var settingTableView: UITableView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    // MARK: Properties

    private let viewModel: SettingViewModelType
    var selectedIndexes: [Int: IndexPath] = [:]

    // MARK: Init

    init(viewModel: SettingViewModelType) {
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
        navBar.updateTitle("Account settings")
        tableViewSetup()
        selectFirstRow()
    }
}

// MARK: - Actions

extension SettingViewController {}

// MARK: - Setup TableView

extension SettingViewController {
    
    func selectFirstRow() {
        let indexPath = IndexPath(row: 0, section: 1)
        settingTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        if let cell: SettingTableViewCell = settingTableView.cellForRow(at: indexPath) as? SettingTableViewCell{
            cell.languageSelectionStyle()
        }
    }
    
    func tableViewSetup() {
        settingTableView.register(SettingTableViewCell.self)
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }
    
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionItem = viewModel.getSectionItem(indexPath.section)
        switch sectionItem.type {
            
        case .Delete:
            if let cell = tableView.cellForRow(at: indexPath) {
                    
                    
                    // إذا كانت لديك خلية مخصصة، يمكنك تحويلها إلى نوعها واستخدام بياناتها
                    if let customCell = cell as? SettingTableViewCell {
                        customCell.showAlertDelegate?.showInCorrectBranchAlert()
                    }
                }
//        showInCorrectBranchAlert()
            
        case .appLanguage:
            selectedIndexes[indexPath.section] = indexPath
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
//        case .notifications:
//            print("handel Notifications")
//        case .account:
//            print("navigate to delete account")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionItem = viewModel.getSectionItem(section)
        return bindTableViewHeader(sectionItem.type.rawValue)
    }
    
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return viewModel.getSectionsNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = viewModel.getSectionItem(section)
        return sectionItem.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = viewModel.getSectionItem(indexPath.section)
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        switch sectionItem.type {
            
        case .Delete:
            cell.configeCell(viewModel.getPasswordRowInfo())
            cell.showAlertDelegate = self
            return cell
            
        case .appLanguage:
            cell.configeCell(viewModel.getLanguageRowInfo(indexPath.row))
            let isSelected = selectedIndexes[indexPath.section] == indexPath
            if isSelected {
                cell.languageSelectionStyle()
            }else {
                cell.languageUnselectionStyle()
            }
            return cell
            
//        case .notifications:
//            cell.configeCell(viewModel.getNotificationRowInfo(indexPath.row))
//            return cell
//            
//        case .account:
//            cell.configeCell(viewModel.getAccountRowInfo())
//            return cell
            
        }
    }
    
}


// MARK: - Private Handlers

private extension SettingViewController {
    
    func bindTableViewHeader(_ headerTitle: String) -> UIView {
        let headerLabel = UILabel()
        headerLabel.text = headerTitle
        headerLabel.backgroundColor = .clear
        headerLabel.font = .B3Bold
        let headerContainerView = UIView()
        headerContainerView.backgroundColor = .clear
        let padding: CGFloat = 24
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 0),
            headerLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: 0),
            headerLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: padding),
            headerLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -padding)
        ])
        
        headerContainerView.frame = CGRect(x: 0, y: 0, width: settingTableView.frame.width, height: 28)
        return headerContainerView
    }
}

extension SettingViewController : RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func showInCorrectBranchAlert() {
        let alert =  CustomAlertViewController()
        alert.alertDelegate = self
        alert.show("Warning!", "You Will Delete Your Account", buttonTitle: "Delete",navigateButtonTitle: "Cancel", .redColor, .warning, flag: false)
    }
    
    func alertButtonClicked() {
        viewModel.logOut { flag in
            if flag {
                self.clearStoredData()
                Defaults.sharedInstance.logout()
                let vc = LoginViewController(viewModel: LoginViewModel())
                self.navigationController?.setViewControllers([vc], animated: true)
            }else{
                CustomAlertViewController().show("Warning!", "Something went wrong please try log out again", buttonTitle: "ok",navigateButtonTitle: "", .redColor, .warning, flag: true)
            }
        }
    }
    
    private func clearStoredData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedEmployeeIds")
        defaults.removeObject(forKey: "selectedServiceTime")
        defaults.synchronize()
    }
}
