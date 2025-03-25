//  
//  AppointmentsViewController.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import UIKit

class AppointmentsViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var emptyAlertView: EmptyStateView!
    @IBOutlet weak var segmentedButtonsView: SegmantedButtons!
    @IBOutlet weak var appointmentTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: Properties
    private var viewModel: AppointmentsViewModelType
    var isEmptyState = false
    var isHistory = true

    // MARK: Init

    init(viewModel: AppointmentsViewModelType) {
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
        if UserDefaults.standard.bool(forKey: "guest"){
            segmentedButtonsView.updateButtonsTitles(String(localized: "history"), String(localized:"upcoming"))
        }else{
            titleLabel.text = String(localized: "myAppointments")
            indicator.startAnimating()
            //  appointmentTableView.isHidden = true
            
            segmentedButtonsView.updateButtonsTitles(String(localized: "history"), String(localized:"upcoming"))
            segmentedButtonsView.delegate = self
            
            //  firstButtonTapped()
            //  secondButtonTapped()
            
            viewModel.reload = { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if self.viewModel.isDataLoaded {
                        self.indicator.stopAnimating()
                        self.appointmentTableView.isHidden = self.viewModel.calenders.isEmpty
                        
                        self.appointmentTableView.reloadData()
                    } else {
                        self.indicator.startAnimating()
                        self.appointmentTableView.isHidden = true
                    }
                    
                    if self.viewModel.calenders.isEmpty {
                        self.appointmentTableView.isHidden = true
                        self.emptyAlertView.isHidden = false
                    } else {
                        self.appointmentTableView.isHidden = false
                        self.emptyAlertView.isHidden = true
                    }
                    self.tableViewSetup()
                    self.bindCalenderButton()
                }
            }
        }
            
                   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Defaults.sharedInstance.navigateToAppoinment(false)
        segmentedButtonsView.secondButton.applyButtonStyle(.selectedSegmentedControl)
        segmentedButtonsView.firstButton.applyButtonStyle(.unSelectedSegmentedControl)
        secondButtonTapped()
        viewModel.reload = { [weak self]  in
            DispatchQueue.main.async {
                self?.appointmentTableView.reloadData()
            }
        }
        
//        func viewDidAppear(_ animated: Bool) {
//            super.viewDidAppear(animated)
//            self.appointmentTableView.isHidden = true
//            firstButtonTapped()
//        }
    }
    
    func tableViewSetup() {
        appointmentTableView.register(AppointmentTableViewCell.self)
        appointmentTableView.delegate = self
        appointmentTableView.dataSource = self
    }
    
    func bindEmptyStateView(msg: String) {
        emptyAlertView.delegate = self
        emptyAlertView.configeView(.emptyAppointment, msg, String(localized: "wouldYouLikeToBookANewAppointment") + "?", String(localized: "exploreServices"))
    }
    
    func bindCalenderButton() {
        calenderButton.addTarget(self, action: #selector(calenderTapped), for: .touchUpInside)
    }
    
    @objc func calenderTapped() {
        let vc = CalenderViewController(viewModel: CalenderViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension AppointmentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension AppointmentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.calenders.count
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: AppointmentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//
//        if viewModel.isDataLoaded {
//            let price = indexPath.row < viewModel.ordersDetails.count ? "\(viewModel.ordersDetails[indexPath.row].total )": ""
//            self.appointmentTableView.reloadRows(at: [indexPath], with: .automatic)
//            cell.configeCell(viewModel.calenders[indexPath.row], price)
//        } else {
//            self.appointmentTableView.reloadRows(at: [indexPath], with: .automatic)
//            cell.configeCell(viewModel.calenders[indexPath.row], "")
//        }
//
//        return cell
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppointmentTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        guard indexPath.row < viewModel.calenders.count else {
            return cell
        }

        if viewModel.isDataLoaded {
            if indexPath.row < viewModel.ordersDetails.count {
                let order = viewModel.ordersDetails[indexPath.row]
                print("🔹 Cell \(indexPath.row): Price = \(order)")
                cell.configeCell(viewModel.calenders[indexPath.row], order)
            } else {
                // Handle the case where ordersDetails is empty or has fewer items than calenders
                cell.configeCell(viewModel.calenders[indexPath.row], nil)
            }
        } else {
            // Handle the case where data is not loaded yet
            cell.configeCell(viewModel.calenders[indexPath.row], nil)
        }
        
        return cell
    }

    // Method to detect if the user has scrolled to the last cell
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let contentHeight = scrollView.contentSize.height
            let contentOffsetY = scrollView.contentOffset.y
            let frameHeight = scrollView.frame.size.height
            
            // Check if the user has scrolled to the bottom
            if contentOffsetY + frameHeight >= contentHeight - 20 {
                if viewModel.currentPage < viewModel.lastPage {
                    indicator.startAnimating()
                    viewModel.getAppointment(type: isHistory ?  "history" : "upcoming") { _ in
                        self.indicator.stopAnimating()
                        self.appointmentTableView.reloadData()
                    }
                }
            }
        }
}




// MARK: - Configurations

extension AppointmentsViewController {}

// MARK: - Private Handlers

private extension AppointmentsViewController {}

extension AppointmentsViewController: SegmantedButtonsDelegation {
    
    func firstButtonTapped() {
        indicator.startAnimating()
        viewModel.reset()
        self.appointmentTableView.isHidden = true
        isHistory = true
        viewModel.getAppointment(type: "history") { [weak self] flag in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                
                if flag {
                    if self?.viewModel.calenders.isEmpty == true {
                        self?.bindEmptyStateView(msg: String(localized: "youDon'tHaveAnyPreviousAppointments"))
                        self?.emptyAlertView.isHidden = false
                        self?.appointmentTableView.isHidden = true
                    } else {
                        self?.emptyAlertView.isHidden = true
                        self?.appointmentTableView.isHidden = false
                        self?.appointmentTableView.reloadData() // استخدم reloadData بدلاً من reloadRows
                    }
                    print("All history appointments fetched successfully.")
                } else {
//                    self?.showErrorAlert(title: "Warning", msg: "Something went wrong. Please try again.", btnTitle: "OK")
                    print("Failed to fetch history appointments.")
                }
            }
        }
    }
    
    
    func secondButtonTapped() {
        indicator.startAnimating()
        viewModel.reset()
        self.appointmentTableView.isHidden = true
        isHistory = false
        viewModel.getAppointment(type: "upcoming") { [weak self] flag in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                
                if flag {
                    if self?.viewModel.calenders.isEmpty == true {
                        self?.bindEmptyStateView(msg: String(localized: "youDon'tHaveAnyUpcomingAppointments"))
                        self?.emptyAlertView.isHidden = false
                        self?.appointmentTableView.isHidden = true
                    } else {
                        self?.emptyAlertView.isHidden = true
                        self?.appointmentTableView.isHidden = false
                        self?.appointmentTableView.reloadData()
                    }
                    print("All upcoming appointments fetched successfully.")
                } else {
//                    self?.showErrorAlert(title: "Warning", msg: "Something went wrong. Please try again.", btnTitle: "OK")
                    print("Failed to fetch upcoming appointments.")
                }
            }
        }
    }
    
}

extension AppointmentsViewController: EmptyStateDelegation {
    func emptyViewButtonTapped() {
        let vc = ServicesViewController(viewModel: ServicesViewModel(false))
        vc.isProduct = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func showErrorAlert(title: String, msg: String, btnTitle: String) {
        if self.presentedViewController == nil {
            let alertVC = CustomAlertViewController()
            alertVC.show(title, msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
            self.present(alertVC, animated: true, completion: nil)
        } else {
            print("⚠️ CustomAlertViewController is already presented.")
        }
    }
}
