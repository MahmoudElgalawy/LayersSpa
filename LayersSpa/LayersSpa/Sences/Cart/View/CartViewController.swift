//  
//  CartViewController.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import UIKit

class CartViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyAlertView: EmptyStateView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var iremsNumLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    // MARK: Properties

    private var viewModel: CartViewModelType
    

    // MARK: Init

    init(viewModel: CartViewModelType) {
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
        titleLabel.text = String(localized: "cart")
        itemsLabel.text = String(localized: "items")
        tableViewSetup()
        bindBookButton()
        bindEmptyStateView()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("flag"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("deleteall"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           viewModel.getCartProductsList(.cart)
      //  for service in viewModel.getCartProductsList(.cart)
       }
       
    func bindBookButton() {
            bookButton.applyButtonStyle(.filled)
            bookButton.setTitle(String(localized: "bookAppointment"), for: .normal)
            bookButton.addTarget(self, action: #selector(bookButtonTapped), for: .touchUpInside)
        }
        
    @objc func bookButtonTapped() {
       // if iremsNumLabel.text != "0" {
                let hasService =  viewModel.productsViewModels.map{ $0.type == "service" }
            let productsIds = viewModel.productsViewModels.map { $0.productId }
            print("📌 Products IDs: \(productsIds)")
            print("is there services ????????????????????????????????????????????????????????\(hasService)")
            if hasService.contains(true){
                let vc = SelectLocationAndDateViewController(viewModel: SelectLocationAndDateViewModel())
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = CheckOutViewController(viewModel: CheckOutViewModel())
                vc.isService = false
                let cost =  priceLabel.text
                if let costText = priceLabel.text, let cost = Double(costText) {
                    vc.cost = cost
                } else {
                    vc.cost = 0.0 // قيمة افتراضية في حالة فشل التحويل
                }
                vc.viewModel.productsId = viewModel.productsViewModels.map{$0.productId}
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
      //  }
         //   else {
//            showNoServicesOrProductAlert()
//        }
    }

        
        func tableViewSetup() {
            cartTableView.register(CartTableViewCell.self)
            cartTableView.delegate = self
            cartTableView.dataSource = self
        }
        
        func bindEmptyStateView() {
            emptyAlertView.delegate = self
            emptyAlertView.configeView(.empryLikes, String(localized: "yourCartIsEmpty"), String(localized: "emptyCartMSG") + "!", String(localized: "exploreServices") )
        }
    @objc func reload() {
        priceLabel.text = "0.0"
        iremsNumLabel.text = "0"
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("flag"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("deleteall"), object: nil)
    }
    }
    // MARK: - Actions

    extension CartViewController {
        func bindViewModel() {
               viewModel.onUpdateLoadingStatus = { [weak self] state in
                   guard let self = self else { return }
                   
                   switch state {
                   case .loading:
                       self.activityIndicator.startAnimating()
                       self.cartTableView.isHidden = true
                   case .loaded:
                       self.activityIndicator.stopAnimating()
                       self.cartTableView.isHidden = false
                   case .empty:
                       self.activityIndicator.stopAnimating()
                       self.cartTableView.isHidden = true
                       self.emptyAlertView.isHidden = false
                       self.bottomView.isHidden = true
                   case .error:
                       self.activityIndicator.stopAnimating()
                       self.cartTableView.isHidden = true
                   }
               }

               viewModel.onReloadData = { [weak self] result in
                   guard let self = self else { return }
                   let isEmpty = result.isEmpty
                   self.cartTableView.isHidden = isEmpty
                   self.emptyAlertView.isHidden = !isEmpty
                   self.bottomView.isHidden = isEmpty
                   self.cartTableView.reloadData()
               }

               viewModel.onReloadTotalPrice = { [weak self] price in
                   guard let self = self else { return }
                   self.priceLabel.text = String(format: "%.2f", price)
               }

               viewModel.onReloadTotalCount = { [weak self] count in
                   guard let self = self else { return }
                   self.iremsNumLabel.text = "\(count)"
                   self.bottomView.isHidden = (count == 0) // إخفاء الـ footer عندما يكون العدد 0
               }
        }
    }

    // MARK: - UITableViewDelegate, UITableViewDataSource

    extension CartViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.getProductssNum()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: CartTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCell(true, cartProduct: viewModel.getProduct(indexPath.row))
            cell.delegate = self
            return cell
        }
    }

    extension CartViewController: EmptyStateDelegation {
        func emptyViewButtonTapped() {
            let vc = ServicesViewController(viewModel: ServicesViewModel(false))
            vc.isProduct = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
//        func showNoServicesOrProductAlert() {
//            CustomAlertViewController().show("Warning", "Please add service or product to your cart before book appointment", buttonTitle: "add service or product", .redColor, .warning)
//        }
        
    }

    extension CartViewController: CartDelegation {
        func deleteCartProduct() {
            viewModel.getCartProductsList(.cart)
            viewModel.onReloadTotalPrice(0.00)
            viewModel.onReloadTotalCount(0)
        }
    }


   
