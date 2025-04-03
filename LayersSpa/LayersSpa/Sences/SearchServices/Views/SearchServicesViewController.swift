//
//  SearchServicesViewController.swift
//  LayersSpa
//
//  Created by Mahmoud on 11/01/2025.
//

import UIKit

class SearchServicesViewController: UIViewController, CustomAlertDelegate, AddToCartAlerts {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var SearchCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var EmptyStateView: EmptyStateView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    
    
    // MARK: Properties
       
       var isProduct = true
       private var viewModel: SearchServicesViewModelProtocol
       var indicator : UIActivityIndicatorView?
       var guest = false
       // MARK: Init

       init(viewModel: SearchServicesViewModelProtocol) {
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
           self.navigationBar.topItem?.title = String(localized: "searchService")
           cancelBtn.title = String(localized: "cancel")
           setIndicator()
           bindViewModel()
           self.hideKeyboardWhenTappedAround()
           if #available(iOS 16.4, *) {
               searchBar.isEnabled = false
           } else {
               // Fallback on earlier versions
           }
           collectionViewSetup()
           navigationBar.layer.borderWidth = 0
           navigationBar.shadowImage = UIImage()
           viewBack.layer.cornerRadius = 10
           viewBack.clipsToBounds = true
           searchBar.customizeSearchBar()
           searchBar.delegate = self
           SearchCollection.layer.borderWidth = 0
           bindEmptyStateView()
           NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedfav"), object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedunfav"), object: nil)
       }
    
    @objc func reloadWish(){
        SearchCollection.reloadData()
        }
    
       // MARK: - Actions
       
       @IBAction func cancelBtn(_ sender: Any) {
           navigationController?.popViewController(animated: true)
       }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }

   }

   // MARK: - Configurations

   extension SearchServicesViewController {
       
       func collectionViewSetup() {
           SearchCollection.register(ProductAndServiceCollectionViewCell.self)
           SearchCollection.delegate = self
           SearchCollection.dataSource = self
           collectionViewLayout()
       }
       
       func collectionViewLayout() {
           let layout = UICollectionViewFlowLayout()

           // spaces between
           layout.sectionInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
           
           let screenWidth = UIScreen.main.bounds.size.width
           let numberOfColumns: CGFloat = 2

           // spaces between elements
           let spacing: CGFloat = 8.0

           // عرض العنصر
           let itemWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - (spacing * (numberOfColumns - 1))) / numberOfColumns

           layout.itemSize = CGSize(width: itemWidth, height: 204.0)
           layout.minimumLineSpacing = spacing
           layout.minimumInteritemSpacing = spacing
           layout.scrollDirection = .vertical

           SearchCollection.collectionViewLayout = layout
       }
       
       func setIndicator(){
           indicator = UIActivityIndicatorView(style: .large)
           indicator?.color = .primaryColor
           indicator?.center = self.view.center
           indicator?.startAnimating()
           self.view.addSubview(indicator!)
       }
       
       func bindViewModel() {
           viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
               guard let self = self else { return }
               self.showError("Invalid", alertMessage)
               print(alertMessage)
           }
           
           viewModel.onReloadData = {[weak self] in
               guard let self = self else { return }
               self.indicator?.stopAnimating()
               if #available(iOS 16.4, *) {
                   self.searchBar.isEnabled = true
               } else {
                   // Fallback on earlier versions
               }
               if self.viewModel.servicesArray == [] {
                   SearchCollection.isHidden = true
                   EmptyStateView.isHidden = false
               }else{
                   SearchCollection.isHidden = false
                   EmptyStateView.isHidden = true
                   self.SearchCollection.reloadData()
               }
           }
           
           viewModel.onUpdateLoadingStatus = { state in
               switch state {
               case .error:
                   print("error")
               case .loading:
                   print("loading")
               case .loaded:
                   print("loaded")
               case .empty:
                   print("empty")
               }
           }
           
           viewModel.getAllServices()
       }
   }

   // MARK: - CollectionView

   extension SearchServicesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return viewModel.getServicesNum()
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell: ProductAndServiceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
           cell.contentView.gestureRecognizers?.forEach(cell.contentView.removeGestureRecognizer)
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToDetails))
           cell.contentView.addGestureRecognizer(tapGesture)
           
           let service = viewModel.getService(indexPath.row)
           
           
           if isProduct {
               cell.configureCellForProduct(service)
           } else {
               cell.configureCellForService(service)
           }
           
           cell.contentView.tag = indexPath.row
           cell.showAlertDelegate = self
           return cell
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          
       }
       
   }

 extension SearchServicesViewController {
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
    
    func bindEmptyStateView() {
        EmptyStateView.configeView(.noSearchResult, String(localized: "noResult"), String(localized: "Unfortunately"))
    }
    
    func showInCorrectBranchAlert() {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning"), String(localized: "selectABranchMSG"), buttonTitle: String(localized: "navigateToHome"),navigateButtonTitle: String(localized: "cancel"), .redColor, .warning, flag: false)
    }
     
     func showGuestAlert(msg: String) {
         let alert = CustomAlertViewController()
         alert.alertDelegate = self
         alert.show(String(localized: "warning") + "!!", "\(msg)", buttonTitle: String(localized: "ok"), navigateButtonTitle: "", .redColor, .warning, flag: true)
     }
     
    
    @objc func navigateToDetails(_ sender: UITapGestureRecognizer){
        guard let tappedView = sender.view else { return }
        let vc = ServiceDetailsViewController(viewModel: ServiceDetailsViewModel())
        vc.serviceId = viewModel.getService(tappedView.tag).productId
        vc.product = viewModel.getService(tappedView.tag)
        vc.servicesList = viewModel.servicesArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//   Mark:-   SearchBar

extension SearchServicesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterServices(by: searchText)
        }
    
    func alertButtonClicked() {
        if UserDefaults.standard.bool(forKey: "guest"){
            
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
}

