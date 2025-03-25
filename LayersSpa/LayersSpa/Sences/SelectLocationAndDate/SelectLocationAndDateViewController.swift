//  
//  SelectLocationAndDateViewController.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import UIKit
import UILayerSpa

class SelectLocationAndDateViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var `continue`: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    
    // MARK: Properties
    
    private var viewModel: SelectLocationAndDateViewModelType
    let footerView = DateFooterView()
    var locations = [Defaults.sharedInstance.branchId?.name]
    
    // MARK: Init
    
    init(viewModel: SelectLocationAndDateViewModelType) {
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
        titleLabel.text = String(localized: "selectLocation&Date")
        footerView.dateLabel.text = String(localized: "selectDate")
        footerView.titleLabel.text = String(localized: "selectDate")
        setupView()
        tableViewSetup()
        bindTableViewHeader()
        bindContinueButton()
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { products in
            let skillIDs = products.compactMap { $0.productId }
            print("skill IDs : \(skillIDs)")
            self.viewModel.fetchEmployeeSkills(skillIDs: skillIDs)
        }
        viewModel.errorAlert = {[weak self] in
            self?.showSelectOtherAlert(msg: String(localized: "selectBranchAndServiceMSG"), btnTitle: String(localized: "ok"))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    func setupView() {
        navBar.delegate = self
        navBar.updateTitle(String(localized: "booking") )
        progressStackView.roundCorners(radius: 6)
        progressView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
        locationTableView.roundCorners(radius: 16)
    }
    
    func selectFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        locationTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        if let cell: FilterAndSortTableViewCell = locationTableView.cellForRow(at: indexPath) as? FilterAndSortTableViewCell {
            cell.selectedStyle()
        }
    }
    
    func tableViewSetup() {
        locationTableView.register(FilterAndSortTableViewCell.self)
        locationTableView.delegate = self
        locationTableView.dataSource = self
        selectFirstRow()
    }
    
    func updateTableViewHeight() {
        tableViewHeightConstraint.constant = CGFloat(locations.count * 64 + 68 + 80)
    }
    
//    func defaultDate() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//
//        let todayDate = dateFormatter.string(from: Date()) // تحويل تاريخ اليوم إلى نص
//        UserDefaults.standard.set(todayDate, forKey: "selectedDate")
//
//    }
}

// MARK: - UITableViewDelegate

extension SelectLocationAndDateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterAndSortTableViewCell else {
            return
        }
        cell.selectionStyle = .none
        cell.selectedStyle()
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FilterAndSortTableViewCell else {
            return
        }
        cell.unSelectedStyle()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension SelectLocationAndDateViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterAndSortTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configeCell(locations[indexPath.row] ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        footerView.delegate = self
        footerView.applyStyle()
        footerView.bindCalenderButton()
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
}

// MARK: - Configurations

extension SelectLocationAndDateViewController {
    
    func bindTableViewHeader() {
        let headerLabel = UILabel()
        headerLabel.text = String(localized: "branch") + " " + "layers"
        headerLabel.backgroundColor = .clear
        headerLabel.font = .B3Bold
        let headerContainerView = UIView()
        headerContainerView.backgroundColor = .clear
        let padding: CGFloat = 24
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 20),
            headerLabel.bottomAnchor.constraint(equalTo: headerContainerView.bottomAnchor, constant: -8),
            headerLabel.leadingAnchor.constraint(equalTo: headerContainerView.leadingAnchor, constant: padding),
            headerLabel.trailingAnchor.constraint(equalTo: headerContainerView.trailingAnchor, constant: -padding)
        ])
        
        headerContainerView.frame = CGRect(x: 0, y: 0, width: locationTableView.frame.width, height: 48)
        locationTableView.tableHeaderView = headerContainerView
    }
}


// MARK: - Actions

extension SelectLocationAndDateViewController {
    
    func bindContinueButton() {
        self.`continue`.setTitle(String(localized: "continue"), for: .normal)
        self.`continue`.applyButtonStyle(.filled)
        self.`continue`.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc func continueTapped() {
        if  footerView.dateLabel.text == String(localized: "selectDate") {
            showSelectOtherAlert(msg: String(localized: "mustSelectDateMSG"), btnTitle: String(localized: "ok"))
        }
        
        if isFriday(dateString:  footerView.dateLabel.text ?? "") {
            showSelectOtherAlert(msg: String(localized: "notAvailableMSG"), btnTitle:  String(localized: "okChooseDifferentDay") )
        } else {
            let vc = SelectProfessionalOptionsViewController(viewModel: SelectProfessionalOptionsViewModel())
            vc.viewModel.employeeIDs = viewModel.employeesID
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    func showSelectOtherAlert(msg:String, btnTitle: String) {
        let alertVC = CustomAlertViewController()
        alertVC.show(String(localized: "weAreSorry"), msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
        present(alertVC, animated: true, completion: nil)
    }
    
//    func showNoDateAlert(msg:String, btnTitle: String) {
//        let alertVC = CustomAlertViewController()
//        alertVC.show("WARNING", msg, buttonTitle: btnTitle, .redColor, .warning)
//        present(alertVC, animated: true, completion: nil)
//    }
}



// MARK: - Private Handlers

private extension SelectLocationAndDateViewController {}

extension SelectLocationAndDateViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectLocationAndDateViewController: DateFooterViewDelegation {
    
    func showDatePicker() {
        let customAlert = CustomDateAlertViewController()
        customAlert.delegate = self
        customAlert.modalPresentationStyle = .overFullScreen
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true, completion: nil)
    }
    
    private func isFriday(dateString: String) -> Bool {
        // إعداد الـ DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // قم بتحديث الصيغة لتطابق النصوص
        
        // تحويل النص إلى كائن Date
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format")
            return false
        }
        
        // استخدام Calendar للحصول على اليوم
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        // التحقق إذا كان اليوم هو الجمعة (الرقم 6)
        return dayOfWeek == 6
    }
}

extension SelectLocationAndDateViewController: CustomDateAlertViewControllerDelegation {
    func updateSelectionDate(_ date: String) {
        footerView.dateLabel.text = date
    }
}

