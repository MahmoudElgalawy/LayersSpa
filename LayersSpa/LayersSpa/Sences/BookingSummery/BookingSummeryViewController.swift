//
//  BookingSummeryViewController.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import UIKit

class BookingSummeryViewController: UIViewController, CartDelegation {
    
    // MARK: Outlets
    
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var bookingSummeryTableView: UITableView!
    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var totalNumLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var navBar: NavigationBarWithBack!
    
    // MARK: Properties
    
    private var viewModel: BookingSummeryViewModelType
    var index = 0
    var indexpath: IndexPath!
    var cost = 0.0
    var isService = true
    
    // MARK: Init
    
    init(viewModel: BookingSummeryViewModelType) {
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
        recalculateTotalCost()
        tableViewSetup()
        bindContinueButton()
        navBar.updateTitle("Booking summery")
        navBar.delegate = self
       // fetchDetails()
//        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("chandedunfav"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("deleteall"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // totalNumLabel.text = "\(cost)"
    }
//    @objc func reload() {
//        fetchDetails()
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("chandedunfav"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("deleteall"), object: nil)
//    }
}

// MARK: - Actions

extension BookingSummeryViewController {
    func tableViewSetup() {
        bookingSummeryTableView.register(BookingDetailsTableViewCell.self)
        bookingSummeryTableView.register(CartTableViewCell.self)
        bookingSummeryTableView.register(BookingFooterTableViewCell.self)
        bookingSummeryTableView.delegate = self
        bookingSummeryTableView.dataSource = self
    }
//    func fetchDetails(){
//        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) {[weak self] services in
//            for service in services {
//                print("Serviceeeeeeeeeeeeee Price ===========\(service.productPrice)")
//                self?.cost += Double(service.productPrice) ?? 0.0
//            }
//        }
//    }
}

// MARK: - UITableViewDelegate

extension BookingSummeryViewController: UITableViewDelegate {
    
    
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

extension BookingSummeryViewController: UITableViewDataSource {
    
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
        case .BookingDetails:
            let cell: BookingDetailsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return cell
            
        case .CartItems:
            let cell: CartTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.containerView.backgroundColor = .grayLight
            cell.contentView.backgroundColor = .whiteColor
            cell.configureCell(false, cartProduct: viewModel.cartItems[indexPath.row])
            cell.delegate = self
            cell.deleteButton.isHidden = true
            index = indexPath.row
            indexpath = indexPath
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

extension BookingSummeryViewController {}

// MARK: - Private Handlers

private extension BookingSummeryViewController {
    
    func bindContinueButton() {
        continueButton.setTitle("Check-out", for: .normal)
        continueButton.applyButtonStyle(.filled)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc func continueTapped() {
        
            let vc = CheckOutViewController(viewModel: CheckOutViewModel())
            //vc.viewModel.cartCount = viewModel.cartItems.count
            vc.viewModel.productsId = viewModel.productsId
            vc.cost = cost
        if isService{
            vc.isService = true
        }else{
            vc.isService = false
        }
            self.navigationController?.pushViewController(vc, animated: true)
    }
        
    
    @objc func handleHeaderTap(_ sender: UITapGestureRecognizer) {
        if let section = sender.view?.tag {
            var sectionItem = viewModel.getSectionItem(section)
            sectionItem.isExpanded.toggle()
            bookingSummeryTableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
}

extension BookingSummeryViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func deleteCartProduct() {
        LocalDataManager.sharedInstance.deleteProduct(viewModel.cartItems[index].productId, .cart) { [weak self] deleted in
            guard let self = self else { return }
            
            self.viewModel.loadCartData()
            
            self.recalculateTotalCost()
            
            self.bookingSummeryTableView.reloadData()
        }
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
            
            // يمكنك تحديث واجهة المستخدم هنا إذا كنت بحاجة لذلك
            DispatchQueue.main.async {
                self.totalNumLabel.text = "\(cost) "  // كمثال لو عندك label في الواجهة
            }
        }
    }

}

