//  
//  CalenderViewController.swift
//  LayersSpa
//
//  Created by marwa on 28/07/2024.
//

import UIKit
import UILayerSpa

class CalenderViewController: UIViewController {

    @IBOutlet private weak var emptyAlertButton: UIButton!
    @IBOutlet private weak var emptyAlertView: UIView!
    @IBOutlet private weak var dataPicker: CustomDatePicker!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var appointmentTableView: UITableView!
    @IBOutlet private weak var appointmentTitleLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: Outlets

    @IBOutlet weak var navBar: NavigationBarWithBack!
    // MARK: Properties

    private var viewModel: CalenderViewModelType

    // MARK: Init

    init(viewModel: CalenderViewModelType) {
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
        appointmentTitleLabel.text = String(localized: "Appointments")
        getCurrentDateappointment()
        tableViewSetup()
        navBar.updateTitle(String(localized: "Calender"))
        navBar.delegate = self
        appointmentTableView.reloadData()
        updateTableViewHeight()
        bindDataPicker()
        bindEmptyStateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        appointmentTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    func bindDataPicker() {
        dataPicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        indicator.startAnimating()
        viewModel.ordersDetails.removeAll()
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Formatted Date: \(formattedDate)")
        
        appointmentTableView.isHidden = true
        emptyAlertView.isHidden = false
        viewModel.getAppointment(date: formattedDate) {[weak self] flag in
            self?.indicator.stopAnimating()
            if flag{
                if self?.viewModel.calenders.isEmpty == true{
                    self?.appointmentTableView.isHidden = true
                    self?.emptyAlertView.isHidden = false
                }else{
                    self?.appointmentTableView.isHidden = false
                    self?.emptyAlertView.isHidden = true
                    self?.appointmentTableView.reloadData()
                }
            }else{
//                self?.showErrorAlert(title: "Warning", msg: "SomeThing Went Wrong,Please Try Again", btnTitle: "Ok")
                self?.appointmentTableView.isHidden = true
                self?.emptyAlertView.isHidden = false
            }
        }
    }

    @IBAction func exploreServicesBtn(_ sender: Any) {
        let vc = ServicesViewController(viewModel: ServicesViewModel(false))
        vc.isProduct = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableViewSetup() {
        appointmentTableView.register(AppointmentTableViewCell.self)
        appointmentTableView.delegate = self
        appointmentTableView.dataSource = self
    }
    
    func updateTableViewHeight() {
        tableViewHeightConstraint.constant = 3 * 200
    }
    
    func bindEmptyStateView() {
        emptyAlertButton.applyButtonStyle(.filled)
        emptyAlertView.roundCorners(radius: 16)
    }
}

// MARK: - UITableViewDelegate

extension CalenderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension CalenderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.calenders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppointmentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        
        guard indexPath.row < viewModel.calenders.count else {
            return cell
        }
        
        let calender = viewModel.calenders[indexPath.row]
        
        let order = (indexPath.row < viewModel.ordersDetails.count) ? viewModel.ordersDetails[indexPath.row] : nil
        
        cell.configeCell(calender, order)
        return cell
    }
    
}



// MARK: - Configurations

extension CalenderViewController {
    func getCurrentDateappointment() {
        indicator.startAnimating()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
      
        
        viewModel.getAppointment(date:dateFormatter.string(from: Date())) {[weak self] flag in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                if flag{
                    if self?.viewModel.calenders.isEmpty == true{
                        self?.appointmentTableView.isHidden = true
                        self?.emptyAlertView.isHidden = false
                    }else{
                        self?.appointmentTableView.isHidden = false
                        self?.emptyAlertView.isHidden = true
                        self?.appointmentTableView.reloadData()
                    }
                }else{
                    self?.showErrorAlert(title: "Warning", msg: "SomeThing Went Wrong,Please Try Again", btnTitle: "Ok")
                }
            }
        }
    }
}

// MARK: - Private Handlers

private extension CalenderViewController {}

extension CalenderViewController: RegistrationNavigationBarDelegate {
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showErrorAlert(title:String ,msg:String, btnTitle: String) {
        let alertVC = CustomAlertViewController()
        alertVC.show("\(title)", msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
        present(alertVC, animated: true, completion: nil)
    }
}


extension CalenderViewController: EmptyStateDelegation {
    func emptyViewButtonTapped() {
        let vc = ServicesViewController(viewModel: ServicesViewModel(false))
        vc.isProduct = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
