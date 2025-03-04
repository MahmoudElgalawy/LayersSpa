//
//  HomeViewController.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController, CustomAlertDelegate {
   
    // MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var topView: HomeTopView!
    
    // MARK: Properties
    
    private var viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    
    // Custom initializer
       init(viewModel: HomeViewModel) {
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
           
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            setupTableView()
            bindViewModel()
            topView.delegate = self
            homeTableView.reloadData()
        }
        
        // MARK: - Setup
        private func setupTableView() {
            homeTableView.register(CategoriesTableViewCell.self)
            homeTableView.register(ShopAndServicesTableViewCell.self)
            homeTableView.delegate = self
            homeTableView.dataSource = self
            homeTableView.showsVerticalScrollIndicator = false
        }
        
        private func bindViewModel() {
            viewModel.onUpdateLoadingStatus = { [weak self] state in
                self?.updateLoadingStatus(state)
            }
            
            viewModel.onReloadData = { [weak self] _ in
                self?.homeTableView.reloadData()
            }
            
            viewModel.onShowNetworkErrorAlert = { [weak self] message in
               // self?.showAlert(message: message)
            }
            
            viewModel.getBranches { [weak self] branches in
                if let branch = Defaults.sharedInstance.branchId, !branch.id.isEmpty {
                    self?.viewModel.getHomeData(branch.id)
                    self?.topView.updateBranchName(branch.name)
                } else {
                    self?.viewModel.getHomeData("")
                    self?.topView.updateBranchName(String(localized: "allBranches"))
                }
            }
        }
        
        private func updateLoadingStatus(_ state: ViewState) {
            switch state {
            case .loading:
                activityIndicator.startAnimating()
                homeTableView.isHidden = true
            case .loaded:
                activityIndicator.stopAnimating()
                homeTableView.isHidden = false
            case .error, .empty:
                activityIndicator.stopAnimating()
                homeTableView.isHidden = true
            }
        }
        
//        private func showAlert(message: String) {
//            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//        }
    }


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getSectionsNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSectionItem(section).rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = viewModel.getSectionItem(indexPath.section)
        
        switch sectionItem.type {
        case .categories:
            let cell: CategoriesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configeCell(viewModel.getCategories())
            cell.delegate = self
            return cell
            
        case .layersShop:
            let cell: ShopAndServicesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configeCellForProducts(viewModel.getProducts())
            cell.delegate = self
            return cell
            
        case .Services:
            let cell: ShopAndServicesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configeCellForServices(viewModel.getServices())
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}



extension HomeViewController: ViewAllDelegation {
    func showIncorrectBranchAlert(msg: String, buttonTitle: String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!!", "\(msg)", buttonTitle: String(localized: "selectBranch"), navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
    
    //Please select a branch before adding item to cart
    func navigateToCategoryServices(_ title: String, _ categotyId: String) {
        let vc = CategoryDetailsViewController(viewModel: CategoryDetailsViewModel())
        vc.navBarTitle = title
        vc.categoryId = categotyId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToDetails(_ serviceId: String,_ product: ProductVM,_ flag:Bool) {
        let vc = ServiceDetailsViewController(viewModel: ServiceDetailsViewModel())
        vc.serviceId = serviceId
        vc.product = product
        vc.servicesList = viewModel.getServices()
        if flag{
            vc.isProduct = true
        }else{
            vc.isProduct = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToCategories() {
        let vc = CategoriesViewController(viewModel: CategoriesViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToProducts() {
        let vc = ServicesViewController(viewModel: ServicesViewModel(false))
        vc.isProduct = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToServices() {
        let vc = ServicesViewController(viewModel: ServicesViewModel(false))
        vc.isProduct = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension HomeViewController: HomeTopViewDelegation {
    
    func showBranchSelection() {
            let vc = FilterViewController()
            vc.delegate = self
            vc.show(viewModel.getBrancesList(), String(localized: "selectBranch"), true)
    }
    
    func navigateToLikes() {
        let vc = LikesViewController(viewModel: LikesViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToNotification() {
        let vc = NotificationViewController(viewModel: NotificationViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSearch() {
        let searchServicesVC = SearchServicesViewController(viewModel: SearchServicesViewModel(true))
        navigationController?.pushViewController(searchServicesVC, animated: true)
       }
    
    func alertButtonClicked() {
        //showBranchSelection()
        self.dismiss(animated: true) { [weak self] in
               // 2. بعد الإغلاق، عرض شاشة الفروع
               guard let self = self else { return }
               let vc = FilterViewController()
               vc.delegate = self
               vc.show(self.viewModel.getBrancesList(), String(localized: "selectBranch"), true)
              // self.present(vc, animated: true)
           }
    }
}

extension HomeViewController: FilterDelegate {
    func showButtonClicked(_ branch: BrancheVM) {
            topView.updateBranchName(branch.name)
            viewModel.getHomeData(branch.id)
            Defaults.sharedInstance.branchId = branch
            dismiss(animated: true)
        }
        
        func navigateToFilter() {
            let filterVC = FilterViewController()
            filterVC.delegate = self
            navigationController?.pushViewController(filterVC, animated: true)
        }
}

protocol ViewAllDelegation: AnyObject {
    func navigateToProducts()
    func navigateToServices()
    func navigateToCategories()
    func navigateToDetails(_ serviceId: String,_ product: ProductVM,_ flag: Bool)
    func navigateToCategoryServices(_ title: String, _ categotyId: String)
    func showIncorrectBranchAlert(msg: String, buttonTitle: String)
}






extension UIApplication {
    var topViewController: UIViewController? {
        guard let rootViewController = keyWindow?.rootViewController else { return nil }
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}
