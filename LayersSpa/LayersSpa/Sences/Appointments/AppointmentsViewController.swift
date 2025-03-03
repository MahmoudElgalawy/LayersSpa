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
        indicator.startAnimating()
              //  appointmentTableView.isHidden = true
                
                segmentedButtonsView.updateButtonsTitles("History", "Upcoming")
                segmentedButtonsView.delegate = self
                
               secondButtonTapped()
            
        viewModel.reload = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if self.viewModel.isDataLoaded {
                    self.indicator.stopAnimating()
                    self.appointmentTableView.isHidden = self.viewModel.calenders.isEmpty // إخفاء الجدول إذا كانت البيانات فارغة
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
    }
    
    func tableViewSetup() {
        appointmentTableView.register(AppointmentTableViewCell.self)
        appointmentTableView.delegate = self
        appointmentTableView.dataSource = self
    }
    
    func bindEmptyStateView(msg: String) {
        emptyAlertView.delegate = self
        emptyAlertView.configeView(.emptyAppointment, msg, "Would you like to book a new appointment?", "Explore services")
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
        print("🔹 عدد الصفوف: \(viewModel.calenders.count)")
        return viewModel.calenders.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AppointmentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if indexPath.row < viewModel.calenders.count {
            if viewModel.isDataLoaded {
                let order = indexPath.row < viewModel.ordersDetails.count ? viewModel.ordersDetails[indexPath.row] : nil
                print("🔹 Cell \(indexPath.row): Price = \(order)")
                if let order = order {
                    cell.configeCell(viewModel.calenders[indexPath.row], order)
                }
            } else {
                // cell.configeCell(viewModel.calenders[indexPath.row], "")
            }
        } else {
            print("❌ خطأ: indexPath.row (\(indexPath.row)) خارج نطاق calenders.count (\(viewModel.calenders.count))")
        }
        return cell
    }
}




// MARK: - Configurations

extension AppointmentsViewController {}

// MARK: - Private Handlers

private extension AppointmentsViewController {}

extension AppointmentsViewController: SegmantedButtonsDelegation {
    
    func firstButtonTapped() {
        indicator.startAnimating()
        self.appointmentTableView.isHidden = true
        isHistory = true
        viewModel.getAppointment(type: "history") { [weak self] flag in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                if flag {
                    if self?.viewModel.calenders.isEmpty == true {
                        self?.bindEmptyStateView(msg: "You don't have any previous appointments")
                        self?.emptyAlertView.isHidden = false
                        self?.appointmentTableView.isHidden = true
                    } else {
                        self?.emptyAlertView.isHidden = true
                        self?.appointmentTableView.isHidden = false
                        self?.appointmentTableView.reloadData()
                    }
                } else {
                }
            }
        }
    }

    func secondButtonTapped() {
        indicator.startAnimating()
        self.appointmentTableView.isHidden = true
        isHistory = false
        viewModel.getAppointment(type: "upcoming") { [weak self] flag in
            DispatchQueue.main.async {
                self?.indicator.stopAnimating()
                if flag {
                    if self?.viewModel.calenders.isEmpty == true {
                        self?.bindEmptyStateView(msg: "You don't have any upcoming appointments.")
                        self?.emptyAlertView.isHidden = false
                        self?.appointmentTableView.isHidden = true
                    } else {
                        self?.emptyAlertView.isHidden = true
                        self?.appointmentTableView.isHidden = false
                        self?.appointmentTableView.reloadData()
                    }
                } else {
                    
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
            //self.present(alertVC, animated: true, completion: nil)
        } else {
            print("⚠️ CustomAlertViewController is already presented.")
        }
    }
}
