//  
//  ServiceDetailsViewController.swift
//  LayersSpa
//
//  Created by marwa on 11/08/2024.
//

import UIKit

class ServiceDetailsViewController: UIViewController, CustomAlertDelegate {
   
    // MARK: Outlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var serviceDetailsTableView: UITableView!
    
    
    // MARK: Properties

    private var viewModel: ServiceDetailsViewModelType
    var serviceId = "0"
    var serviceDetailsData: ServiceDetailVM?
    var product: ProductVM!
    var isProduct = true
    var homeViewModel = HomeViewModel()
    var servicesList: [ProductVM] = []

    // MARK: Init

    init(viewModel: ServiceDetailsViewModelType) {
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
      //  getMightLike()
        print("Services might love+++++++++++++++++++++++++++++++ \(servicesList)")
        tableViewSetup()
        bindAddToCartButton()
        bindBackButton()
        bindViewModel()
        updateFavAndAddButtons()
    }
    
    @objc func handleHomeDataReceived(_ notification: Notification){
        if let services = notification.object as? [ProductVM] { // استبدل HomeData بنوع البيانات الفعلي
            servicesList = services
                }
    }
    
    func bindAddToCartButton() {
        addToCartButton.applyButtonStyle(.filled)
        addToCartButton.setTitle("Add To Cart", for: .normal)
        addToCartButton.addTarget(self, action: #selector(AddButtonTapped), for: .touchUpInside)
    }
    
    @objc func AddButtonTapped() {
        guard let branchId = Defaults.sharedInstance.branchId?.id else {
            showInCorrectBranchAlert()
            return
        }
        if product.branchesId.contains("\(branchId)") {
            if addToCartButton.titleLabel?.text == "Add To Cart" {
                LocalDataManager.sharedInstance.addLikeProductsToCoreData(productsList: product, .cart)
                updateFavAndAddButtons()
            }else{
                LocalDataManager.sharedInstance.deleteProduct(product.productId, .cart) { [weak self] deleted in
                    if deleted{
                        self?.updateFavAndAddButtons()
                    }
                }
            }
        }else{
            showInCorrectBranchAlert()
        }
        
    }
    
    func bindBackButton() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favButtonTapped(_ sender: Any) {
        if likeButton.imageView?.image == UIImage(systemName: "heart.fill"){
            if isProduct{
                LocalDataManager.sharedInstance.deleteProduct(product.productId, .product) { [weak self] deleted in
                    if deleted{
                        self?.updateFavAndAddButtons()
                    }
                }
            }else{
                LocalDataManager.sharedInstance.deleteProduct(product.productId, .service) { [weak self] deleted in
                    if deleted{
                        self?.updateFavAndAddButtons()
                    }
                }
            }
        }else{
            if isProduct{
                LocalDataManager.sharedInstance.addLikeProductsToCoreData(productsList: product, .product)
                updateFavAndAddButtons()
            }else{
                LocalDataManager.sharedInstance.addLikeProductsToCoreData(productsList: product, .service)
                updateFavAndAddButtons()
            }
        }
    }
    
}

// MARK: - Setup TableView

extension ServiceDetailsViewController {
    
    func tableViewSetup() {
        serviceDetailsTableView.register(ServiceImageTableViewCell.self)
        serviceDetailsTableView.register(ServiceDescriptionTableViewCell.self)
        //serviceDetailsTableView.register(ReviewTableViewCell.self)
        serviceDetailsTableView.register(ServiceMightLikeTableViewCell.self)
        serviceDetailsTableView.delegate = self
        serviceDetailsTableView.dataSource = self
    }
    
//    func getMightLike(){
//        homeViewModel.getBranches { [weak self] branches in
//                guard let self = self else { return }
//                if let branch = Defaults.sharedInstance.branchId {
//                    if branch.id != "" {
//                        self.homeViewModel.getHomeData(branch.id)
//                    }
//                } else {
//                    self.homeViewModel.getHomeData("")
//                }
//            }
//    }
    
}

// MARK: - UITableViewDelegate

extension ServiceDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

// MARK: - UITableViewDataSource

extension ServiceDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return viewModel.getSectionsNumber()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  viewModel.getSectionItem(section).rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = viewModel.getSectionItem(indexPath.section)
        
        switch sectionItem.type {
            
        case .serviceImage:
            let cell: ServiceImageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configureCell(serviceDetailsData)
            return cell
            
        case .serviceDescription:
            let cell: ServiceDescriptionTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configureCell(serviceDetailsData)
            return cell

//        case .serviceReviews:
//            let cell: ReviewTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//            cell.configureCell(serviceDetailsData)
//            return cell
            
        case .serviceMightLike:
            let cell: ServiceMightLikeTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.servicesList = servicesList
            return cell
            
        }
    }
    
}


// MARK: - Configurations

extension ServiceDetailsViewController: ServiceDetailsDelegation {
    func didSelectService(_ service: ProductVM) {
        let vc = ServiceDetailsViewController(viewModel: ServiceDetailsViewModel())
                vc.serviceId = service.productId
                vc.product = service
                vc.isProduct = false
                self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func readMoreDescription() {
        print("read more")
    }
    
//    func viewAllReviews() {
//        let vc = AllReviewsViewController(viewModel: AllReviewsViewModel())
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
//    }
    
//    func writeReviews() {
//        WriteReviewViewController().show()
//    }
    
}

// MARK: - bind view model

extension ServiceDetailsViewController {
    
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            //self.showError("Invalid", alertMessage)
            SomeThingWentWrong(msg:"Some Thing Went Wrong Please Try Again", btnTitle: "Ok")
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            print("result, ", result)
            serviceDetailsData = result
            self.serviceDetailsTableView.reloadData()
        }
        
        viewModel.onUpdateLoadingStatus = { [weak self] state in
            
            guard let self = self else { return }
            
            switch state {
            case .error:
                print("error")
                activityIndicator.stopAnimating()
            case .loading:
                print("loading")
                activityIndicator.startAnimating()
            case .loaded:
                print("loaded")
                activityIndicator.stopAnimating()
            case .empty:
                print("empty")
            }
        }
        
        viewModel.getServiceDetails(serviceId)
    }
    
}

// MARK: - Private Handlers

private extension ServiceDetailsViewController {
    
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
    
    private func updateFavAndAddButtons() {

        if isProduct{
            if LocalDataManager.sharedInstance.checkProductExist(product.productId, .product) {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeButton.tintColor = .red
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                likeButton.tintColor = .gray
            }
        }else{
            if LocalDataManager.sharedInstance.checkProductExist(product.productId, .service) {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                likeButton.tintColor = .red
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                likeButton.tintColor = .gray
            }
        }
        if LocalDataManager.sharedInstance.checkProductExist(product.productId, .cart){
            addToCartButton.setTitle("Remove From Cart", for: .normal)
        }else{
            addToCartButton.setTitle("Add To Cart", for: .normal)
        }
    }
}

extension ServiceDetailsViewController: AddToCartAlerts {
    func SomeThingWentWrong(msg: String, btnTitle: String) {
        CustomAlertViewController().show("Warning!", "\(msg)", buttonTitle: "\(btnTitle)",navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
//    
    func showInCorrectBranchAlert() {
        let alert =  CustomAlertViewController()
        alert.alertDelegate = self
        alert.show("Warning", "Please select a branch before adding item to cart", buttonTitle: "Navigate To Home",navigateButtonTitle: "Cancel", .redColor, .warning, flag: false)
    }
    
    func alertButtonClicked() {
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




