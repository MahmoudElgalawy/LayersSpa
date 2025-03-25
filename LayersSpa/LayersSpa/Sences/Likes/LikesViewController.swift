//
//  LikesViewController.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import UIKit

class LikesViewController: UIViewController, CustomAlertDelegate {
   
    // MARK: Outlets
    
    @IBOutlet weak var emptyAlertView: EmptyStateView!
    @IBOutlet private weak var likesCollectionView: UICollectionView!
    @IBOutlet private weak var segmentedButtonsView: SegmantedButtons!
    @IBOutlet private weak var navBar: NavigationBarWithBack!
    
    // MARK: Properties
    
    private var isProductCell = true
    var flag = false
    
    
    private var viewModel: LikesViewModelType
    
    // MARK: Init
    
    init(viewModel: LikesViewModelType) {
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
        navBar.updateTitle(String(localized: "likes"))
        segmentedButtonsView.updateButtonsTitles(String(localized: "products"), String(localized: "services"))
        segmentedButtonsView.delegate = self
        navBar.delegate = self
        collectionViewSetup()
        bindEmptyStateView()
        bindViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedfav"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedunfav"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
   
    @objc func reloadWish(){
        viewModel.getLikeProductsList(.service)
        likesCollectionView.reloadData()
        reloadproducts()
    }
    @objc func reloadproducts(){
        viewModel.getLikeProductsList(.product)
        likesCollectionView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("chandedfav"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("chandedunfav"), object: nil)
    }
}

// MARK: - Actions

extension LikesViewController {
    func bindEmptyStateView() {
        emptyAlertView.delegate = self
        emptyAlertView.configeView(.empryLikes, String(localized: "noLikedItemsYet"), String(localized: "checkOutOurProducts"), String(localized: "exploreProducts"))
    }
}

// MARK: - Configurations

extension LikesViewController {
    
    func collectionViewSetup() {
        likesCollectionView.register(ProductAndServiceCollectionViewCell.self)
        likesCollectionView.delegate = self
        likesCollectionView.dataSource = self
        collectionViewLayout()
    }
    
    func collectionViewLayout() {
//        var x = 2.2
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        likesCollectionView.contentInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
//        if UIScreen.main.bounds.size.width < 400 {
//            x = 2.4
//        }
//        layout.itemSize = CGSize(width: likesCollectionView.frame.width / x, height: 204.0)
//        layout.minimumLineSpacing = 8
//        layout.scrollDirection = .vertical
//        likesCollectionView.collectionViewLayout = layout
        let layout = UICollectionViewFlowLayout()

        // الحواف بين الأقسام
        layout.sectionInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)

        // عرض الشاشة
        let screenWidth = UIScreen.main.bounds.size.width

        // عدد الأعمدة
        let numberOfColumns: CGFloat = 2

        // المسافة بين العناصر
        let spacing: CGFloat = 8.0

        // عرض العنصر = (عرض الشاشة - الحواف اليسرى واليمنى - المسافات بين العناصر) / عدد الأعمدة
        let itemWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - (spacing * (numberOfColumns - 1))) / numberOfColumns

        // تعيين حجم العنصر
        layout.itemSize = CGSize(width: itemWidth, height: 204.0)

        // تعيين المسافات بين الأسطر
        layout.minimumLineSpacing = spacing

        // تعيين المسافات بين الأعمدة
        layout.minimumInteritemSpacing = spacing

        // الاتجاه عمودي
        layout.scrollDirection = .vertical

        // تطبيق التخطيط على CollectionView
        likesCollectionView.collectionViewLayout = layout
    }
}

// MARK: - CollectionView

extension LikesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductAndServiceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        if isProductCell {
            cell.configureCellForProduct(viewModel.getProduct(indexPath.row))
        } else {
            cell.configureCellForService(viewModel.getService(indexPath.row))
        }
        cell.showAlertDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = isProductCell ? viewModel.getProductssNum() : viewModel.getServicesNum()
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ServiceDetailsViewController(viewModel: ServiceDetailsViewModel())
        if isProductCell{
            vc.serviceId = viewModel.getProduct(indexPath.row).productId
            vc.product = viewModel.getProduct(indexPath.row)
            vc.servicesList = viewModel.servicesViewModels
            vc.isProduct = true
        }else{
            vc.serviceId = viewModel.getService(indexPath.row).productId
            vc.product = viewModel.getService(indexPath.row)
            vc.isProduct = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



// MARK: - bind view model

extension LikesViewController {
    func bindViewModel() {
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            if result.count > 0 {
                likesCollectionView.isHidden = false
                emptyAlertView.isHidden = true
                self.likesCollectionView.reloadData()
            }
            else {
                likesCollectionView.isHidden = true
                emptyAlertView.isHidden = false
            }
        }
        
        viewModel.getLikeProductsList(.product)
    }
}

extension LikesViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension LikesViewController: SegmantedButtonsDelegation {
    func firstButtonTapped() {
        isProductCell = true
                viewModel.getLikeProductsList(.product)
                likesCollectionView.reloadData()
                
                // تحديث نص الزر عند عرض المنتجات
                emptyAlertView.configeView(.empryLikes, String(localized: "noLikedItemsYet"), String(localized: "checkOutOurProducts"), String(localized: "exploreProducts"))
    }
    
    func secondButtonTapped() {
        isProductCell = false
                viewModel.getLikeProductsList(.service)
                likesCollectionView.reloadData()
                
                // تحديث نص الزر عند عرض الخدمات
                emptyAlertView.configeView(.empryLikes, String(localized: "noLikedItemsYet"), String(localized: "checkOutOurServices"), String(localized:"exploreServices") )
            }
    
}

extension LikesViewController: EmptyStateDelegation {
    func emptyViewButtonTapped() {
        if isProductCell {
            let vc = ServicesViewController(viewModel: ServicesViewModel(false))
            vc.isProduct = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ServicesViewController(viewModel: ServicesViewModel(false))
            vc.isProduct = false
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

extension LikesViewController: CoreDataDelegation {
    func reloadDataAfterDelete(_ type: CoreDataProductType) {
        viewModel.getLikeProductsList(type)
    }
}

extension LikesViewController: AddToCartAlerts {
    func showInCorrectBranchAlert() {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!!", String(localized: "selectABranchMSG"), buttonTitle: String(localized: "navigateToHome"), navigateButtonTitle: String(localized: "cancel"), .redColor, .warning, flag: false)
    }
    
    func alertButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showGuestAlert(msg: String) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning") + "!!", "\(msg)", buttonTitle: String(localized: "ok"), navigateButtonTitle: "", .redColor, .warning, flag: true)
    }
}

