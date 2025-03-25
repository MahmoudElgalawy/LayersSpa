//
//  ShopAndServicesTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import UIKit
import UILayerSpa

class ShopAndServicesTableViewCell: UITableViewCell, IdentifiableView {
    
    @IBOutlet private weak var productAndServiceCollectionView: UICollectionView!
    @IBOutlet private weak var viewAllArrow: UIImageView!
    @IBOutlet private weak var viewAllButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private let layout = UICollectionViewFlowLayout()
    weak var delegate: ViewAllDelegation?
    private var productsList: [ProductVM] = []
    private var servicesList: [ProductVM] = []
    private var isProductCell = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("flag"), object: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productsList.removeAll()
        servicesList.removeAll()
        productAndServiceCollectionView.reloadData()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            viewAllArrow.image = nil
        }
    }
    
    override func layoutSubviews() {
        collectionViewSetup()
        collectionViewLayout()
        bindViewAllButton()
    }
    
    func configeCellForProducts(_ productsInfo: [ProductVM]) {
        self.productsList = productsInfo
        titleLabel.text = String(localized: "layersShop")
        viewAllButton.setTitle(String(localized: "viewAll"), for: .normal)
        rotateImageBasedOnLanguage()
        isProductCell = true
        productAndServiceCollectionView.reloadData()
    }
    
    func configeCellForServices(_ servicesInfo: [ProductVM]) {
        self.servicesList = servicesInfo
        titleLabel.text = String(localized: "popularServices")
        viewAllButton.setTitle(String(localized: "viewAll"), for: .normal)
        rotateImageBasedOnLanguage()
        isProductCell = false
        productAndServiceCollectionView.reloadData()
    }
    
    func rotateImageBasedOnLanguage() {
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
        viewAllArrow.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    func bindViewAllButton() {
        viewAllButton.removeTarget(nil, action: nil, for: .allEvents)
        
        if isProductCell {
            viewAllButton.addTarget(self, action: #selector(navigateToProducts), for: .touchUpInside)
        } else {
            viewAllButton.addTarget(self, action: #selector(navigateToServices), for: .touchUpInside)
        }
    }
    
    
    func collectionViewSetup() {
        productAndServiceCollectionView.register(ProductAndServiceCollectionViewCell.self)
        productAndServiceCollectionView.delegate = self
        productAndServiceCollectionView.dataSource = self
    }
    
    func collectionViewLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        productAndServiceCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        productAndServiceCollectionView.collectionViewLayout = layout
    }
    @objc func reload() {
        productAndServiceCollectionView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("flag"), object: nil)
    }
}

extension ShopAndServicesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductAndServiceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        if isProductCell {
            cell.configureCellForProduct(productsList[indexPath.row])
        } else {
            cell.configureCellForService(servicesList[indexPath.row])
        }
        cell.showAlertDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = isProductCell ? productsList.count : servicesList.count
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("product selected")
        if isProductCell {
            delegate?.navigateToDetails(productsList[indexPath.row].productId, productsList[indexPath.row], true)
        } else {
            delegate?.navigateToDetails(servicesList[indexPath.row].productId, servicesList[indexPath.row], false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width: CGFloat = 148
        return CGSize(width: width, height: height)
    }
    
}

extension ShopAndServicesTableViewCell {
    @objc func navigateToProducts() {
        delegate?.navigateToProducts()
    }
    
    @objc func navigateToServices() {
        delegate?.navigateToServices()
    }
}

//extension ShopAndServicesTableViewCell: AddToCartAlerts {
//    func SomeThingWentWrong(msg: String, btnTitle: String) {
//        delegate?.showIncorrectBranchAlert()
//    }
//    
//    func showInCorrectBranchAlert() {
//        delegate?.showIncorrectBranchAlert()
//    }
//}

extension ShopAndServicesTableViewCell: AddToCartAlerts {
    func showGuestAlert(msg: String) {
        delegate?.showGuestAlert(msg: msg, buttonTitle: String(localized: "ok") )
    }
    
    
    func showInCorrectBranchAlert() {
        delegate?.showIncorrectBranchAlert(msg: String(localized: "selectABranchMSG"), buttonTitle: String(localized: "selectBranch") )
    }
}
