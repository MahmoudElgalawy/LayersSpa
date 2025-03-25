//  
//  ServicesViewController.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import UIKit

class ServicesViewController: UIViewController, CustomAlertDelegate {

    // MARK: Outlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    
    // MARK: Properties
    var isProduct = true
    private var viewModel: ServicesViewModelType
    var guest = false

    // MARK: Init

    init(viewModel: ServicesViewModelType) {
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
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("flag"), object: nil)
        let title = String(localized: isProduct ? "products" : "services")
        navBar.updateTitle(title)
        navBar.delegate = self
        collectionViewSetup()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        servicesCollectionView.reloadData()
    }
    
    @objc func reload() {
        servicesCollectionView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("flag"), object: nil)
    }
}

// MARK: - Actions

extension ServicesViewController {
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            self.showInCorrectBranchAlert()
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            print("result, ", result)
            self.servicesCollectionView.reloadData()
        }
        
        viewModel.onUpdateLoadingStatus = { [weak self] state in
            
            guard let self = self else { return }
            
            switch state {
            case .error:
                print("error")
                activityIndicator.stopAnimating()
                self.showInCorrectBranchAlert()
            case .loading:
                print("loading")
                activityIndicator.startAnimating()
            case .loaded:
                print("loaded")
                activityIndicator.stopAnimating()
            case .empty:
                print("empty")
                self.showInCorrectBranchAlert()
            }
        }
        if isProduct{
            viewModel.getAllServices("purchases", branchId: Defaults.sharedInstance.branchId?.id ?? "")
        }else{
            viewModel.getAllServices("Service", branchId: Defaults.sharedInstance.branchId?.id ?? "")
        }
    }
    
}


// MARK: - Configurations

extension ServicesViewController {
    
    func collectionViewSetup() {
        servicesCollectionView.register(ProductAndServiceCollectionViewCell.self)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
           collectionViewLayout()
       }
       
       func collectionViewLayout() {
           let layout = UICollectionViewFlowLayout()

           layout.sectionInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
           let screenWidth = UIScreen.main.bounds.size.width
           let numberOfColumns: CGFloat = 2
           let spacing: CGFloat = 8.0
           let itemWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - (spacing * (numberOfColumns - 1))) / numberOfColumns
           layout.itemSize = CGSize(width: itemWidth, height: 204.0)
           layout.minimumLineSpacing = spacing
           layout.minimumInteritemSpacing = spacing
           layout.scrollDirection = .vertical
           servicesCollectionView.collectionViewLayout = layout
       }
}

// MARK: - CollectionView

extension ServicesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductAndServiceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if isProduct {
            cell.configureCellForProduct(viewModel.getService(indexPath.row))
        } else {
            cell.configureCellForService(viewModel.getService(indexPath.row))
        }
        
        cell.showAlertDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = viewModel.getServicesNum()
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ServiceDetailsViewController(viewModel: ServiceDetailsViewModel())
        vc.serviceId = viewModel.getService(indexPath.row).productId
        vc.product = viewModel.getService(indexPath.row)
        vc.servicesList = viewModel.servicesViewModels
        if isProduct {
            vc.isProduct = true
        }else{
            vc.isProduct = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Private Handlers

private extension ServicesViewController {
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
}

extension ServicesViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension ServicesViewController : AddToCartAlerts {
  
    func showInCorrectBranchAlert() {
        let alert =  CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!", String(localized: "selectABranchMSG"), buttonTitle: String(localized: "navigateToHome"), navigateButtonTitle: String(localized: "cancel"), .redColor, .warning, flag: false)
    }
    
    func alertButtonClicked() {
        if guest {
            
        }else{
            Defaults.sharedInstance.navigateToAppoinment(false)
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

    
//    func SomeThingWentWrong(msg:String, btnTitle: String) {
//        let alertVC = CustomAlertViewController()
//        alertVC.show("Warning", msg, buttonTitle: btnTitle, .redColor, .warning)
//        present(alertVC, animated: true, completion: nil)
//    }
    
    func showGuestAlert(msg: String) {
        guest = true
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!!", "\(msg)", buttonTitle: String(localized: "ok"), navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
}


