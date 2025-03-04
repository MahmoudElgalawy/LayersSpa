//  
//  SelectProfessionalPerServiceViewController.swift
//  LayersSpa
//
//  Created by 2B on 30/07/2024.
//

import UIKit

class SelectProfessionalPerServiceViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var professionalPerServiceTableView: UITableView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: Properties

    var viewModel: SelectProfessionalPerServiceViewModelType
    var selectedCellIndexpathRow: Int = 0
    var delegate: BookingStepDelegation?
    var selectedProfessionalsPerService: [Int: Employee] = [:]
    var selectedTimesPerService: [Int: String] = [:]
    var Employees = [selectedProfessionalVM]()
    var anyProf = false
    var oneProf = true

    // MARK: Init

    init(viewModel: SelectProfessionalPerServiceViewModelType) {
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
        professionalPerServiceTableView.showsVerticalScrollIndicator = false
        clearStoredData()
        tableViewSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("chandedunfav"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(handleTimeSelectedNotification(_:)), name: Notification.Name("TimeSelectedNotification"), object: nil)
        //    }
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            self?.viewModel.services = services
            let placeholder = selectedProfessionalVM(profImage: "", profName: "")
            self?.Employees = Array(repeating: placeholder, count: services.count)
            
//            // تحديد موظف واحد فقط لكل الخدمات إذا كان anyProf مفعلاً
//            if let defaultEmployee = self?.viewModel.members.first {
//                self?.viewModel.services.forEach { service in
//                    self?.selectedProfessionalsPerService[Int(service.productId) ?? 0] = defaultEmployee
//                }
//            }
            
            self?.professionalPerServiceTableView.reloadData()
            self?.bindDismissButton()
            self?.bindContinueButton()
        }

    }
//    //chandedunfav
    func tableViewSetup() {
        professionalPerServiceTableView.register(ProfessionalPerServiceTableViewCell.self)

        professionalPerServiceTableView.delegate = self
        professionalPerServiceTableView.dataSource = self
    }
    
    func bindDismissButton() {
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }
    
    @objc func dismissTapped() {
        self.selectedProfessionalsPerService.removeAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reload() {
        print("Service Deeeeeeee")
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
                self?.viewModel.services = services
                self?.professionalPerServiceTableView.reloadData()
            }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("chandedunfav"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TimeSelectedNotification"), object: nil)
    }
}

// MARK: - UITableViewDelegate

extension SelectProfessionalPerServiceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        viewModel.services[indexPath.row].type != "service" ? 170 : 350
    }
}

// MARK: - UITableViewDataSource

extension SelectProfessionalPerServiceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfessionalPerServiceTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        
        let service = viewModel.services[indexPath.row]
        cell.configureService(service)
        cell.layoutIfNeeded()
        
        // الحالة 1: anyProf مفعل (أقل موظف مشغول لجميع الخدمات)
        if anyProf {
            if let defaultEmployee = viewModel.members.first {
                selectedProfessionalsPerService[Int(service.productId) ?? 0] = defaultEmployee
                cell.applySelectedProfessional(defaultEmployee)
                if let selectedTime = selectedTimesPerService[Int(service.productId) ?? 0] {
                    cell.applySelectedTime(time: selectedTime)
                } else {
                    cell.resetTimeSelection()
                }
            }
            return cell
        }
        // الحالة 2: oneProf مفعل (موظف واحد لجميع الخدمات)
        else if oneProf {
            // لا نعيّن موظفًا افتراضيًا هنا
            if let selectedEmployee = selectedProfessionalsPerService.values.first {
                // تطبيق الموظف المختار على جميع الخدمات
                selectedProfessionalsPerService[Int(service.productId) ?? 0] = selectedEmployee
                cell.applySelectedProfessional(selectedEmployee)
                if let selectedTime = selectedTimesPerService[Int(service.productId) ?? 0] {
                    cell.applySelectedTime(time: selectedTime)
                } else {
                    cell.resetTimeSelection()
                }
            } else {
                // الخلية تبقى فارغة حتى يقوم المستخدم باختيار موظف
                cell.resetSelections()
            }
            return cell
        }
        // الحالة 3: موظف لكل خدمة
        else {
            if let selectedProfessional = selectedProfessionalsPerService[Int(service.productId) ?? 0] {
                cell.applySelectedProfessional(selectedProfessional)
                if let selectedTime = selectedTimesPerService[Int(service.productId) ?? 0] {
                    cell.applySelectedTime(time: selectedTime)
                } else {
                    cell.resetTimeSelection()
                }
            } else {
                // الخلية تبقى فارغة حتى يقوم المستخدم باختيار موظف
                cell.resetSelections()
            }
            return cell
        }
    }
}


// MARK: - Configurations

extension SelectProfessionalPerServiceViewController {
    func bindContinueButton() {
        continueButton.setTitle(String(localized: "continue"), for: .normal)
        continueButton.applyButtonStyle(.filled)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    
//    @objc func continueTapped() {
//        let allServicesSelected = viewModel.services.allSatisfy { service in
//            return selectedProfessionalsPerService[Int(service.productId) ?? 0] != nil
//        }
//        
//        if !allServicesSelected {
//            showNoTimeSelectedAlert(msg: "Please Select Professional For All Services before book Continue", btnTitle: "Select Professional")
//            return
//        }
//        
//        let allTimesSelected = viewModel.services.allSatisfy { service in
//            return selectedTimesPerService[Int(service.productId) ?? 0] != nil
//        }
//        
//        if !allTimesSelected {
//            showNoTimeSelectedAlert(msg: "Please select a time for all services before continuing", btnTitle: "Select Time")
//            return
//        }
//        
//        // طباعة الموظفين والأوقات المحددة
//        for (serviceId, employee) in selectedProfessionalsPerService {
//            if let service = viewModel.services.first(where: { Int($0.productId) == serviceId }) {
//                let time = selectedTimesPerService[Int(service.productId) ?? 0] ?? "لم يتم تحديد الوقت"
//                print("الخدمة: \(service.productName) - الموظف: \(employee.empData.name) - الوقت: \(time)")
//            }
//        }
//        let employeeIds = selectedProfessionalsPerService.values.compactMap { $0.empData.id }
//        UserDefaults.standard.set(employeeIds, forKey: "selectedEmployeeIds")
//        
//        // الانتقال إلى الشاشة التالية
//        let vc = BookingSummeryViewController(viewModel: BookingSummeryViewModel())
//        vc.isService = true
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//    
    
    @objc func continueTapped() {
        // تصفية الخدمات التي نوعها "service"
        let serviceTypeServices = viewModel.services.filter { $0.type == "service" }
        
        // التحقق من تحديد موظف لكل خدمة
        let allServicesSelected = serviceTypeServices.allSatisfy { service in
            return selectedProfessionalsPerService[Int(service.productId) ?? 0] != nil
        }
        
        if !allServicesSelected {
            showNoTimeSelectedAlert(msg: String(localized: "selectProfessionalForAllServices"), btnTitle: String(localized: "selectProfessional"))
            return
        }
        
        // التحقق من تحديد وقت لكل خدمة
        let allTimesSelected = serviceTypeServices.allSatisfy { service in
            return selectedTimesPerService[Int(service.productId) ?? 0] != nil
        }
        
        if !allTimesSelected {
            showNoTimeSelectedAlert(msg: String(localized: "selectTimeForAllServices"), btnTitle: String(localized: "selectTime"))
            return
        }
        
        // طباعة الموظفين والأوقات المحددة
        for (serviceId, employee) in selectedProfessionalsPerService {
            if let service = viewModel.services.first(where: { Int($0.productId) == serviceId }) {
                let time = selectedTimesPerService[Int(service.productId) ?? 0] ?? "لم يتم تحديد الوقت"
                print("الخدمة: \(service.productName) - الموظف: \(employee.empData.name) - الوقت: \(time)")
            }
        }
        
        let employeeIds = selectedProfessionalsPerService.values.compactMap { $0.empData.id }
        UserDefaults.standard.set(employeeIds, forKey: "selectedEmployeeIds")
        
        // الانتقال إلى الشاشة التالية
        let vc = BookingSummeryViewController(viewModel: BookingSummeryViewModel())
        vc.isService = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Private Handlers

private extension SelectProfessionalPerServiceViewController {}

extension SelectProfessionalPerServiceViewController: ProfessionalPerServiceTableViewCellDelegation {
    
    func selectTime(_ cell: UITableViewCell, Completion: @escaping (String) -> ()) {
        guard let indexPath = professionalPerServiceTableView.indexPath(for: cell) else { return }
        let service = viewModel.services[indexPath.row]
        
        // تحقق من أن نوع الخدمة هو "service"
        guard service.type == "service" else {
            print("هذه الخدمة ليست من نوع service")
            return
        }
        
        guard let selectedProfessional = selectedProfessionalsPerService[Int(service.productId) ?? 0] else {
            print("No professional selected for this service")
            return
        }
        
        let vc = BookTimeSlotsViewController(viewModel: BookTimeSlotsViewModel())
        vc.isPerService = true
        vc.times = SelectProfessionalOptionsViewController(viewModel: SelectProfessionalOptionsViewModel())
            .findAvailableSlots(employee: selectedProfessional, date: Date(), spliter: ((service.unit ?? 15) * service.productCount))
        vc.selectedServiceId = service.productId
        
        vc.completionHandler = { [weak self] selectedTime in
            guard let self = self else { return }
            
            // حفظ الوقت المحدد
            self.selectedTimesPerService[Int(service.productId) ?? 0] = selectedTime
            Completion(selectedTime)
            
            // إعادة تحميل الخلية المعنية
            if let indexPath = self.professionalPerServiceTableView.indexPath(for: cell) {
                self.professionalPerServiceTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        self.present(vc, animated: true)
    }
    
    func selectProfessional(_ cell: UITableViewCell, Completion completion: @escaping (Employee) -> ()) {
        guard let indexPath = professionalPerServiceTableView.indexPath(for: cell) else { return }
        let service = viewModel.services[indexPath.row]
        
        // تحقق من أن نوع الخدمة هو "service"
        guard service.type == "service" else {
            print("هذه الخدمة ليست من نوع service")
            return
        }
        
        let vc = SelectProfessionalMemberViewController(viewModel: SelectProfessionalMemberViewModel())
        vc.viewModel.members = viewModel.members
        vc.isPerService = true
        
        vc.completionHandler = { [weak self] employee in
            guard let self = self else { return }
            
            if self.oneProf {
                // تعيين الموظف لجميع الخدمات من نوع "service"
                for service in self.viewModel.services where service.type == "service" {
                    self.selectedProfessionalsPerService[Int(service.productId) ?? 0] = employee
                }
            } else {
                // تعيين الموظف للخدمة الحالية فقط
                self.selectedProfessionalsPerService[Int(service.productId) ?? 0] = employee
            }
            
           // self.selectedTimesPerService.removeAll()
            completion(employee)
            self.professionalPerServiceTableView.reloadData()
        }
        
        self.present(vc, animated: true)
    }
    
    func showNoTimeSelectedAlert(msg: String, btnTitle: String) {
        CustomAlertViewController().show(String(localized: "warning"), "\(msg)", buttonTitle: "\(btnTitle)",navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
}

extension SelectProfessionalPerServiceViewController  {
    
    private func clearStoredData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedEmployeeIds")
        defaults.removeObject(forKey: "selectedServiceTime")
        defaults.synchronize()
    }
}

extension SelectProfessionalPerServiceViewController: SelectNewTimeDelegate {
    func didSelectNewTime(_ time: String) {
        if let cell = professionalPerServiceTableView.cellForRow(at: IndexPath(row: selectedCellIndexpathRow, section: 0)) as? ProfessionalPerServiceTableViewCell {
            cell.applySelectedTime(time: time)
            //professionalPerServiceTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func printSelectedProfessionalsWithTime() {
        for (serviceId, employee) in selectedProfessionalsPerService {

            if let service = viewModel.services.first(where: { Int($0.productId) == serviceId }) {

                guard let storedTimes = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] else { return }
                let time = storedTimes[String(serviceId)] ?? "لم يتم تحديد الوقت"
                
                print("الخدمة: \(service.productName) - الموظف: \((employee.empData.name)!) - الوقت: \(time)")
            }
        }
    }

}


protocol BookingSummeryDelegate: AnyObject {
    func didUpdateTable()
}










