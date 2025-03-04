//  
//  SelectProfessionalOptionsViewController.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import UIKit
import UILayerSpa

class SelectProfessionalOptionsViewController: UIViewController, CustomAlertDelegate {
  
    // MARK: Outlets

    @IBOutlet weak var selectProfessionalTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    // MARK: Properties

     var viewModel: SelectProfessionalOptionsViewModelType
     var indicator : UIActivityIndicatorView?
    
    
    let options: [SelectProfessionalOptionsVM] = [
        SelectProfessionalOptionsVM(cellImage: .selectProf1, title: String(localized: "anyProfessional"), subTitle: String(localized: "forMaximumAvailability")),
        SelectProfessionalOptionsVM(cellImage: .selectProf2, title: String(localized: "selectOneProfessional"), subTitle: String(localized: "forAllServices")),
        SelectProfessionalOptionsVM(cellImage: .selectProf3, title: String(localized: "selectProfessional"), subTitle: String(localized: "perService"))
    ]

    // MARK: Init

    init(viewModel: SelectProfessionalOptionsViewModelType) {
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
        selectProfessionalTableView.isHidden = true
        self.setupView()
        self.tableViewSetup()
        setIndicator()
        titleLabel.text = String(localized: "selectProfessional")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAvailableEmployees(date: UserDefaults.standard.string(forKey: "selectedDate")!, branchID: Defaults.sharedInstance.branchId?.id ?? "2", employeeIDs: viewModel.employeeIDs)
        self.indicator?.startAnimating()
        viewModel.onDataFetched = {[weak self] in
            self?.indicator?.stopAnimating()
            self?.selectProfessionalTableView.isHidden = false
        }
        viewModel.onError = { [weak self] _ in
            self?.showSelectOtherAlert(msg: String(localized: "selectDateAndBranchMSg"), btnTitle: String(localized: "ok"))
        }
    }
    
    func setupView() {
        navBar.delegate = self
        navBar.updateTitle(String(localized: "booking"))
        progressStackView.roundCorners(radius: 6)
        progressView.roundCorners(radius: 6)
        stepLabel.roundCorners(radius: 16)
    }
    
    func tableViewSetup() {
        selectProfessionalTableView.register(SelectProfessionalOptionsTableViewCell.self)
        selectProfessionalTableView.delegate = self
        selectProfessionalTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension SelectProfessionalOptionsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0 :
            let vc = SelectProfessionalPerServiceViewController(viewModel: SelectProfessionalPerServiceViewModel())
            if let leastWorkingEmployee = self.findEmployeeWithLeastWorkingTime(employees: self.viewModel.availableEmployees , date: Date()) {
                vc.viewModel.members.append(leastWorkingEmployee)
            }
            vc.delegate = self
            vc.anyProf = true
            vc.oneProf = false
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = SelectProfessionalPerServiceViewController(viewModel: SelectProfessionalPerServiceViewModel())
            vc.delegate = self
            vc.viewModel.members = viewModel.availableEmployees
            vc.anyProf = false
            vc.oneProf = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = SelectProfessionalPerServiceViewController(viewModel: SelectProfessionalPerServiceViewModel())
           // vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.viewModel.members = viewModel.availableEmployees
            vc.anyProf = false
            vc.oneProf = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            print("invalid")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension SelectProfessionalOptionsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: SelectProfessionalOptionsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configeCell(options[indexPath.row])
        return cell
    }
    
}


// MARK: - Configurations

extension SelectProfessionalOptionsViewController {}

// MARK: - Private Handlers

private extension SelectProfessionalOptionsViewController {}

extension SelectProfessionalOptionsViewController: RegistrationNavigationBarDelegate {
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension SelectProfessionalOptionsViewController: BookingStepDelegation {
    func navigateToBooking() {
        let vc = BookingSummeryViewController(viewModel: BookingSummeryViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setIndicator(){
        indicator = UIActivityIndicatorView(style: .large)
        indicator?.color = .primaryColor
        indicator?.center = self.view.center
        indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
}

protocol BookingStepDelegation {
    func navigateToBooking()
}

// Mark:- calculate Free Time 

extension SelectProfessionalOptionsViewController{

    func toLocalTime(_ timeString: String) -> DateComponents {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        if let date = formatter.date(from: timeString) {
            return Calendar.current.dateComponents([.hour, .minute, .second], from: date)
        }
        return DateComponents()
    }

    func toLocalDateTime(_ dateTimeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.date(from: dateTimeString)
    }

    func calculateWorkingTime(workingHours: WorkingHours, busyEvents: [OtherEvent], date: Date) -> Int {
        let calendar = Calendar.current
        
        let workStartTime = toLocalTime(workingHours.from!)
        let workEndTime = toLocalTime(workingHours.to!)
        
        let todayStart = calendar.date(bySettingHour: workStartTime.hour ?? 0, minute: workStartTime.minute ?? 0, second: 0, of: date)!
        let todayEnd = calendar.date(bySettingHour: workEndTime.hour ?? 0, minute: workEndTime.minute ?? 0, second: 0, of: date)!

        let sortedBusyTimes = busyEvents.compactMap { event -> (Date, Date)? in
            guard let start = toLocalDateTime(event.start!), let end = toLocalDateTime(event.end!) else { return nil }
            return (start, end)
        }.sorted { $0.0 < $1.0 }

        var totalWorkingMinutes = 0

        for (busyStart, busyEnd) in sortedBusyTimes {
            if busyStart >= todayStart && busyEnd <= todayEnd {
                totalWorkingMinutes += calendar.dateComponents([.minute], from: busyStart, to: busyEnd).minute ?? 0
            }
        }

        return totalWorkingMinutes
    }

    func findEmployeeWithLeastWorkingTime(employees: [Employee], date: Date) -> Employee? {
        return employees.enumerated().map { (index, employee) in
            (employee, calculateWorkingTime(workingHours: employee.workingHours, busyEvents: employee.otherEvents, date: date))
        }.min { $0.1 < $1.1 }?.0
    }
}


extension SelectProfessionalOptionsViewController {

    func findAvailableSlots(employee: Employee, date: Date, spliter: Int) -> [String] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let workStartTime = toLocalTime(employee.workingHours.from!)
        let workEndTime = toLocalTime(employee.workingHours.to!)
        
        guard let workStart = calendar.date(bySettingHour: workStartTime.hour ?? 0, minute: workStartTime.minute ?? 0, second: 0, of: date),
              let workEnd = calendar.date(bySettingHour: workEndTime.hour ?? 0, minute: workEndTime.minute ?? 0, second: 0, of: date) else {
            return []
        }

        let busyIntervals = employee.otherEvents.compactMap { event -> (Date, Date)? in
            guard let start = toLocalDateTime(event.start!), let end = toLocalDateTime(event.end!) else { return nil }
            return (start, end)
        }.sorted { $0.0 < $1.0 }
        
        var freeSlots: [String] = []
        var currentSlotStart = workStart
        
        while currentSlotStart < workEnd {
            let nextSlotStart = calendar.date(byAdding: .minute, value: spliter, to: currentSlotStart)!
            
            let isBusy = busyIntervals.contains { (busyStart, busyEnd) in
                return !(nextSlotStart <= busyStart || currentSlotStart >= busyEnd)
            }
            
            if !isBusy {
                let slot = "\(formatter.string(from: currentSlotStart))-\(formatter.string(from: nextSlotStart))"
                freeSlots.append(slot)
            }
            
            currentSlotStart = nextSlotStart
        }
        
        return freeSlots
    }


    func showSelectOtherAlert(msg:String, btnTitle: String) {
        let alertVC = CustomAlertViewController()
        alertVC.alertDelegate = self
        alertVC.show(String(localized: "weAreSorry"), msg, buttonTitle: btnTitle,navigateButtonTitle: "", .redColor, .warning, flag: true)
        present(alertVC, animated: true, completion: nil)
    }
    
    func alertButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
