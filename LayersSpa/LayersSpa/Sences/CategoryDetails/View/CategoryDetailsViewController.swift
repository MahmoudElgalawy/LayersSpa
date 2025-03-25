//  
//  CategoryDetailsViewController.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import UIKit
import Combine
import Alamofire
import Networking

class CategoryDetailsViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var navBar: NavigationBarWithBack!
    @IBOutlet weak var viewBack: UIView!
    
    // MARK: Properties
    var navBarTitle = ""
    var categoryId = "0"
   var eempty = true
    private var viewModel: CategoryDetailsViewModelType
    private var cancellables = Set<AnyCancellable>()

    // MARK: Init

    init(viewModel: CategoryDetailsViewModelType) {
        self.viewModel = viewModel
        //self.network = NetworkService()
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
       // networking()

        viewBack.layer.cornerRadius = 10
        viewBack.clipsToBounds = true
        searchBar.customizeSearchBar()
        searchBar.delegate = self
        navBar.delegate = self
        //searchView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("flag"), object: nil)
        navBar.updateTitle(navBarTitle)
        collectionViewSetup()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        serviceCollectionView.reloadData()
    }
    @objc func reload() {
        serviceCollectionView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("flag"), object: nil)
    }
}


// MARK: - Actions
extension CategoryDetailsViewController {
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            SomeThingWentWrong(msg: String(localized: "noServiceMSG"), btnTitle: String(localized: "ok"))
            //self.showError("Invalid", alertMessage)
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            //print("result, ", result)
            self.serviceCollectionView.reloadData()
        }
        
        viewModel.onUpdateLoadingStatus = { [weak self] state in
            
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .error:
                    print("error")
                    self.activityIndicator.stopAnimating()
                case .loading:
                    print("loading")
                    self.activityIndicator.startAnimating()
                case .loaded:
                    print("loaded")
                    self.activityIndicator.stopAnimating()
                case .empty:
                    print("empty")
                }
            }
        }
        viewModel.getCategoryServices(categoryId)
    }
    
}


// MARK: - Configurations

extension CategoryDetailsViewController {
    
    func collectionViewSetup() {
           serviceCollectionView.register(ProductAndServiceCollectionViewCell.self)
           serviceCollectionView.delegate = self
           serviceCollectionView.dataSource = self
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

           serviceCollectionView.collectionViewLayout = layout
       }
}

// MARK: - CollectionView

extension CategoryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductAndServiceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureCellForService(viewModel.getService(indexPath.row))
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
        vc.isProduct = false
        vc.product =  viewModel.getService(indexPath.row)
        vc.servicesList = viewModel.getServices()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



// MARK: - Private Handlers

private extension CategoryDetailsViewController {
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
}

extension CategoryDetailsViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryDetailsViewController: SearchWithFilterAndSortViewDelegation {
    func showFilter() {
        print("filter")
        FilterViewController().show()
    }
    
    func showSort() {
        print("sort")
        SortViewController().show()
    }
    
}
extension CategoryDetailsViewController: AddToCartAlerts {
    func showInCorrectBranchAlert() {
        eempty = false
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!!", String(localized: "selectABranchMSG"), buttonTitle: String(localized: "navigateToHome"), navigateButtonTitle: String(localized: "cancel"), .redColor, .warning, flag: false)
    }
    
    func SomeThingWentWrong(msg: String, btnTitle: String) {
        eempty = true
       let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning"), "\(msg)", buttonTitle: "\(btnTitle)",navigateButtonTitle: "", .redColor, .warning,flag: true)
    }
    
//    func showInCorrectBranchAlert() {
//        CustomAlertViewController().show("Warning", "Please select a branch before adding item to cart", buttonTitle: "select branch", .redColor, .warning)
//    }
}

//   Mark:-   SearchBar

extension CategoryDetailsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           viewModel.filterServices(by: searchText)
        }
}


extension CategoryDetailsViewController: CustomAlertDelegate {
    
    func alertButtonClicked() {
        if eempty{
            self.navigationController?.popViewController(animated: true)
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
    
    func showGuestAlert(msg: String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!!", "\(msg)", buttonTitle: String(localized: "ok"), navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
}
