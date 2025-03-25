//
//  CheckOutViewController.swift
//  LayersSpa
//
//  Created by marwa on 02/08/2024.
//

import UIKit
import UILayerSpa

class CheckOutViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var navBar: NavigationBarWithBack!
    @IBOutlet private weak var checkoutTableView: UITableView!
    @IBOutlet private weak var totalNumLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var continueButton: UIButton!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var viewModel: CheckOutViewModelType
    var cost = 0.0
    var method = true
    var visa = false
    var isService = true
    var done = true
    var creditCard: [BookingSummerySectionsVM] = [
        BookingSummerySectionsVM(sectionIcon: .visa, sectionTitle: "Master Card - 5453"),
        BookingSummerySectionsVM(sectionIcon: .visamaster, sectionTitle: "Master Card - 5453")]
    
    // MARK: Init
    
    init(viewModel: CheckOutViewModelType) {
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
       // recalculateTotalCost()
        self.indicator.stopAnimating()
        totalNumLabel.text = "\(cost)"
        viewModel.firstRequest()
        tableViewSetup()
        bindContinueButton()
        navBar.updateTitle(String(localized: "checkOut"))
        totalLabel.text = String(localized: "total")
        navBar.delegate = self
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAddNewButtonPressed),
                                               name: .addNewButtonPressed,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addCardPressed),
                                               name: .addCardPressed,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let paymentCell = checkoutTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PaymentTableViewCell {
            paymentCell.loadSavedCreditCards()  // إعادة تحميل البطاقات
            paymentCell.paymentTableView.reloadData()  // تحديث الجدول
            paymentCell.updateTableViewHeight()  // تحديث الارتفاع
        }
    }

    
}

// MARK: - Actions

extension CheckOutViewController {
    
    @objc func handleAddNewButtonPressed() {
        let vc = AddNewPaymentViewController(viewModel: AddNewPaymentViewModel())
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @objc func addCardPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.checkoutTableView.reloadData()
            CustomAlertViewController().show(String(localized: "addCardSuccessTitleMSG") + "!", String(localized: "addCartSuccessSubtitleMSG") + ".", buttonTitle: String(localized: "continue"),navigateButtonTitle: "",.primaryColor,.alertImage, flag: true)
        }
    }
}

// MARK: - Actions

extension CheckOutViewController {
    
    func tableViewSetup() {
//        checkoutTableView.register(DiscoundCodeTableViewCell.self)
//        checkoutTableView.register(OrderSummeryTableViewCell.self)
        checkoutTableView.register(PaymentTableViewCell.self)
        checkoutTableView.register(BookingFooterTableViewCell.self)
        checkoutTableView.delegate = self
        checkoutTableView.dataSource = self
    }
    
}

// MARK: - UITableViewDelegate

extension CheckOutViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .whiteColor
        footer.roundBottomCorners(radius: 16)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionItem = viewModel.getSectionItem(section)
        if sectionItem.type == .Footer {
            return 0
        }
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        headerView.backgroundColor = .whiteColor
        headerView.roundTopCorners(radius: 16)
        let sectionItem = viewModel.getSectionItem(section)
        headerView.configureHeaderView(viewModel.getSectionHeaderInfo(section), sectionItem.isExpanded)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleHeaderTap(_:)))
        headerView.addGestureRecognizer(tapGestureRecognizer)
        headerView.tag = section
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionItem = viewModel.getSectionItem(section)
        if sectionItem.type == .Footer {
            return 0
        }
        return 78
    }
}

// MARK: - UITableViewDataSource

extension CheckOutViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionsNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionItem = viewModel.getSectionItem(section)
        return sectionItem.isExpanded ? sectionItem.rowCount : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionItem = viewModel.getSectionItem(indexPath.section)
        switch sectionItem.type {
            
//        case .DiscoundCode:
//            let cell: DiscoundCodeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//            return cell
//            
//        case .OrderSummery:
//            let cell: PaymentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//            cell.viewModel = self.viewModel
//            cell.branches =   [ BookingSummerySectionsVM(sectionIcon: .visa, sectionTitle: "Master Card - 5453"),BookingSummerySectionsVM(sectionIcon:.visamaster, sectionTitle: "Master Card - 5453")]
//            return cell
            
        case .Payment:
            let cell: PaymentTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.viewModel = self.viewModel
            
            return cell
            
        case .Footer:
            let cell: BookingFooterTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



// MARK: - Configurations

extension CheckOutViewController {}

// MARK: - Private Handlers

private extension CheckOutViewController {
    
    func bindContinueButton() {
        continueButton.setTitle(String(localized: "checkOut"), for: .normal)
        continueButton.applyButtonStyle(.filled)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc func continueTapped() {
        
        let value = String(localized: "visa")
        
        if viewModel.selectedPaymentMethod != nil{
            
            // Mark:- Service not product

            if isService{
                
                // Mark:- Choose Visa Method
                
                

                if viewModel.selectedPaymentMethod == value{
                    
                    // Mark:- Select Card

                    if viewModel.visa != nil {
                        indicator.startAnimating()
                        viewModel.abandonedState(){ [weak self] flag in
                            if flag{
                                self?.viewModel.reservation(){[weak self] status in
                                    if status{
                                        self?.viewModel.bookingConfirmation(completion: { done in
                                            if done{
                                                self?.viewModel.PaymentConfirmation(name: self?.viewModel.visa?.cardHolder ?? "" , visaNumber: self?.viewModel.visa?.cardNumber ?? "", month: self?.viewModel.visa?.month ?? "", year:  self?.viewModel.visa?.year ?? "", cvc: self?.viewModel.visa?.cvv ?? "",total: "\((self?.cost)!)") {[weak self] success in
                                                    if success {
                                                        DispatchQueue.main.async {
                                                            self?.indicator.stopAnimating()
                                                            self?.visa = true
                                                           // self?.showDismissAlert(message: "Your Order Booked Successful✔️")
                                                            //   self?.visa = true
                                                            self?.showAlert(title: String(localized: "orderSuccessTitle"), msg: String(localized: "orderSuccessSubtitle"), btnTitle: String(localized: "viewAppointments"), buttonColor: .primaryColor, flag: false,image: .alertImage)
                                                            self?.clearStoredData()
                                                        }
                                                    }else{
                                                        DispatchQueue.main.async {
                                                            self?.indicator.stopAnimating()
                                                            self?.method = false
                                                            self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                                                        }
                                                    }
                                                }
//
                                            }else{
                                                DispatchQueue.main.async {
                                                    self?.indicator.stopAnimating()
                                                    self?.method = false
                                                    self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                                                }
                                            }
                                        })
                                    }else{
                                        DispatchQueue.main.async {
                                            self?.indicator.stopAnimating()
                                            self?.method = false
                                            self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                                        }
                                    }
                                }
                            }else{
                                DispatchQueue.main.async {
                                    self?.indicator.stopAnimating()
                                    self?.method = false
                                    self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                                }
                            }
                        }
                    }else{
                        
                        // Mark:- Did not select card

                        self.showAlert(title: String(localized: "warning") + "!!", msg:  String(localized: "choosCardMSG"), btnTitle: String(localized: "ok"))
                    }
                }else{
                    
                    // Mark:- Choose Cash
                    
                    indicator.startAnimating()
                    viewModel.abandonedState(){ [weak self] flag in
                        if flag{
                            self?.viewModel.reservation(){[weak self] status in
                                if status{
                                    self?.viewModel.bookingConfirmation(completion: { done in
                                        if done{
                                            DispatchQueue.main.async {
                                                self?.indicator.stopAnimating()
                                                self?.method = true
                                             //   self?.showDismissAlert(message: "Your Order Booked Successful")
                                                self?.showAlert(title: String(localized: "orderSuccessTitle"), msg: String(localized: "orderSuccessSubtitle"), btnTitle: String(localized: "viewAppointments"), buttonColor: .primaryColor, flag: false,image: .alertImage)
                                                self?.clearStoredData()
                                            }
                                        }else{
                                            DispatchQueue.main.async {
                                                self?.indicator.stopAnimating()
                                                self?.method = false
                                                self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                                            }
                                        }
                                    })
                                }else{
                                    DispatchQueue.main.async {
                                        self?.indicator.stopAnimating()
                                        self?.method = false
                                        self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                                    }
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                self?.indicator.stopAnimating()
                                self?.method = false
                                self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "serviceAtThisTimeMSG"), btnTitle: String(localized: "ok"))
                            }
                        }
                    }
                }
            }else{
                // Mark:- product not Service
                if viewModel.selectedPaymentMethod == value{
                    if viewModel.visa != nil {
                        
                        indicator.startAnimating()
                        viewModel.abandonedState(){ [weak self] flag in
                            if flag{
                                self?.viewModel.PaymentConfirmation(name: self?.viewModel.visa?.cardHolder ?? "" , visaNumber: self?.viewModel.visa?.cardNumber ?? "", month: self?.viewModel.visa?.month ?? "", year:  self?.viewModel.visa?.year ?? "", cvc: self?.viewModel.visa?.cvv ?? "",total: "\((self?.cost)!)") {[weak self] success in
                                    if success {
                                        DispatchQueue.main.async {
                                            self?.indicator.stopAnimating()
                                            self?.visa = true
                                         //   self?.showDismissAlert(message: "Your Order Booked Successful✔️")
                                            //   self?.visa = true
                                            self?.showAlert(title: String(localized: "orderSuccessTitle"), msg: String(localized: "orderSuccessSubtitle"), btnTitle: String(localized: "viewAppointments"), buttonColor: .primaryColor, flag: false,image: .alertImage)
                                            self?.clearStoredData()
                                        }
                                    }else{
                                        DispatchQueue.main.async {
                                            self?.indicator.stopAnimating()
                                            self?.method = false
                                            self?.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "checkCardBalanceMSG"), btnTitle: String(localized: "ok"))
                                        }
                                    }
                                }
//
                            }else{
                                DispatchQueue.main.async {
                                    self?.indicator.stopAnimating()
                                    self?.method = false
                                    self?.showAlert(title: String(localized: "warning") + "!!", msg:  String(localized: "checkOutFaluireMSG"), btnTitle: String(localized: "ok"))
                                }
                            }
                        }
                    }else{
                        self.showAlert(title: String(localized: "warning") + "!!", msg:  String(localized: "choosCardMSG"), btnTitle: String(localized: "ok"))
                    }
                }else{
                    indicator.startAnimating()
                    viewModel.abandonedState(){ [weak self] flag in
                        if flag{
                            DispatchQueue.main.async {
                                self?.indicator.stopAnimating()
                                self?.visa = false
                                self?.method = true
                                //// Done
                               // self?.showDismissAlert(message: "Your Order Booked Successful")
                                self?.showAlert(title: String(localized: "orderSuccessTitle"), msg: String(localized: "orderSuccessSubtitle"), btnTitle: String(localized: "viewAppointments"), buttonColor: .primaryColor, flag: false,image: .alertImage)
                                //   self?.visa = true
                                self?.clearStoredData()
                            }
                        }else{
                            DispatchQueue.main.async {
                                self?.indicator.stopAnimating()
                                self?.method = false
                                self?.showAlert(title: String(localized: "warning") + "!!", msg:  String(localized: "checkOutFaluireMSG"), btnTitle: String(localized: "ok"))
                            }
                        }
                    }
                }
            }
            } else{
                self.method = false
                self.showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "selectPaymentMSG"), btnTitle: String(localized: "ok"))
            }
        

        }
    
    
    @objc func handleHeaderTap(_ sender: UITapGestureRecognizer) {
        if let section = sender.view?.tag {
            var sectionItem = viewModel.getSectionItem(section)
            sectionItem.isExpanded.toggle()
            checkoutTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
    
}

extension CheckOutViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension CheckOutViewController: CustomAlertDelegate {
    
    func alertButtonClicked() {
        if done{
            
        }else{
            Defaults.sharedInstance.navigateToAppoinment(true)
            let customTabBarController = CustomTabBarViewController()
            let navigationController = UINavigationController(rootViewController: customTabBarController)
            guard let window = UIApplication.shared.currentWindow else {
                print("No current window found")
                return
            }
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
    

    func showAlert(title:String ,msg:String, btnTitle: String,buttonColor: UIColor = .redColor,flag: Bool = true,image: UIImage = .warning) {
            done = flag
            let alertVC = CustomAlertViewController()
            alertVC.show("\(title)", msg, buttonTitle: btnTitle,navigateButtonTitle: "", buttonColor, image, flag: true)
            alertVC.alertDelegate = self
            present(alertVC, animated: true, completion: nil)
    }
    
    private func clearStoredData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedEmployeeIds")
        defaults.removeObject(forKey: "selectedServiceTime")
        defaults.synchronize()
        LocalDataManager.sharedInstance.deleteAllData(.cart)
    }
    
    
    private func showDismissAlert(message: String) {
        let alert = UIAlertController(title: "Done✔️", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { action in
            print("Choosed Visa ========================================= \(String(describing: self.viewModel.visa))")
                   
                
        }))
        present(alert, animated: true)
    }
    
    
    private func recalculateTotalCost() {
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            guard let self = self else { return }
            var cost = 0.0
            for service in services {
                cost += (Double(service.productPrice) ?? 0) * Double(service.productCount)
            }
            self.cost = cost

            print("إجمالي التكلفة: \(self.cost)")
            
            DispatchQueue.main.async {
                self.totalNumLabel.text = "\(cost) "
            }
        }
    }
}

extension Notification.Name {
    static let addNewButtonPressed = Notification.Name("addNewButtonPressed")
    static let addCardPressed = Notification.Name("addCardPressed")
}



