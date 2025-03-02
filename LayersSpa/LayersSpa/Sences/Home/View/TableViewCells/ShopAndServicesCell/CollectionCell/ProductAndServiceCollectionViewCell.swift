//
//  ProductAndServiceCollectionViewCell.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class ProductAndServiceCollectionViewCell: UICollectionViewCell, IdentifiableView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var addToWishListButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewsNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var serviceRatingStackView: UIStackView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    // Properties to hold data and state
        var isAddedToWishList = false
        var isAddedToCart = false
        var isService = true
        var cellProduct: ProductVM?
        var delegate: CoreDataDelegation?
        var showAlertDelegate: AddToCartAlerts?
        
        override func awakeFromNib() {
            super.awakeFromNib()
            setupCell()
            bindAddToWishListButton()
            bindAddToCartButton()
        }
        
        // Configure cell UI components
        func setupCell() {
            self.roundCorners(radius: 16)
            image.roundCorners(radius: 14)
            addToWishListButton.roundCorners(radius: 8)
            addToWishListButton.backgroundColor = UIColor.black20
        }
        
        // Configure cell for displaying products
        func configureCellForProduct(_ product: ProductVM) {
            isService = false
            let url = URL(string: product.productImage)
            image.kf.setImage(with: url)
            nameLabel.text = product.productName
            priceLabel.text = "\(product.productPrice)"
            sizeLabel.text = product.productSize
            serviceRatingStackView.isHidden = true
            sizeLabel.isHidden = false
            cellProduct = product
            updateWishListAndCartButtons()
        }
        
        // Configure cell for displaying services
        func configureCellForService(_ service: ProductVM) {
            isService = true
            let url = URL(string: service.productImage)
            image.kf.setImage(with: url,placeholder: UIImage(named: "products"))
            nameLabel.text = service.productName
            priceLabel.text = "\(service.productPrice)"
            ratingLabel.text = "\(service.productRating)"
            reviewsNumberLabel.text = "(\(service.productRateNumber))"
            sizeLabel.isHidden = true
            serviceRatingStackView.isHidden = false
            cellProduct = service
            updateWishListAndCartButtons()
        }
    
//        func configeCellForDummyServices(_ service: ProductVM) {
//            isService = true
//            image.image = UIImage(named: "\(service.productImage)")
//            nameLabel.text = service.productName
//            priceLabel.text = "\(service.productPrice)"
//            ratingLabel.text = "\(service.productRating)"
//            reviewsNumberLabel.text = "(\(service.productRateNumber))"
//            sizeLabel.isHidden = true
//            serviceRatingStackView.isHidden = false
//            cellProduct = service
//            isAddedToWishList = LocalDataManager.sharedInstance.checkProductExist(service.productId, .service)
//            let image: UIImage = isAddedToWishList ? .redHeart : .heart
//            addToWishListButton.setImage(image, for: .normal)
//            
//            isAddedToCart = LocalDataManager.sharedInstance.checkProductExist(service.productId, .cart)
//            let addImage: UIImage = isAddedToCart ? .decreaseButton : .addButton
//            addToCartButton.setImage(addImage, for: .normal)
//        }
//        
        
        
        // Update button states for WishList and Cart based on the product's current state
        private func updateWishListAndCartButtons() {
            guard let product = cellProduct else { return }
            let productType: CoreDataProductType = isService ? .service : .product
            
            isAddedToWishList = LocalDataManager.sharedInstance.checkProductExist(product.productId, productType)
            let heartImage: UIImage = isAddedToWishList ? .redHeart : .heart
            addToWishListButton.setImage(heartImage, for: .normal)
            
            isAddedToCart = LocalDataManager.sharedInstance.checkProductExist(product.productId, .cart)
            let cartImage: UIImage = isAddedToCart ? .decreaseButton : .addButton
            addToCartButton.setImage(cartImage, for: .normal)
        }
        
        // Bind the Add to WishList button action
        func bindAddToWishListButton() {
            addToWishListButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        }
        
        // Handle the action when the like button is tapped
        @objc func likeTapped() {
            guard let product = cellProduct else { return }
            let productType: CoreDataProductType = isService ? .service : .product
            
            if isAddedToWishList {
                LocalDataManager.sharedInstance.deleteProduct(product.productId, productType) { [weak self] result in
                    self?.delegate?.reloadDataAfterDelete(productType)
                }
            } else {
                LocalDataManager.sharedInstance.addLikeProductsToCoreData(productsList: product, productType)
            }
            // Toggle the like status and update button image
            isAddedToWishList.toggle()
            updateWishListAndCartButtons()
        }
    }

    extension ProductAndServiceCollectionViewCell {
        
        // Bind the Add to Cart button action
        func bindAddToCartButton() {
            addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        }
        
        // Handle the action when the Add to Cart button is tapped
        @objc func addToCartTapped() {
            guard let product = cellProduct else { return }
            
            if isAddedToCart {
                LocalDataManager.sharedInstance.deleteProduct(product.productId, .cart) { [weak self] result in
                NotificationCenter.default.post(name:  Notification.Name("flag")
                                                    , object: nil, userInfo: ["flag": "true"])
                    self?.updateCartButton()
                }
            } else {
                handleCartProduct(product)
            }
        }
        
  //  msg: "SomeThing Went Wrong Please Select Branch Again", btnTitle: " Ok"
        
        private func handleCartProduct(_ product: ProductVM) {
            guard let branchId = Defaults.sharedInstance.branchId?.id else {
                //SomeThingWentWrong(msg:"Please select a branch before adding item to cart", btnTitle: "select branch")
                showAlertDelegate?.showInCorrectBranchAlert()
                return
            }

            // Debugging - Print Branches and Current ID
            print("Branches: \(product.branchesId)")
            print("Current Branch ID: \(branchId)")

            if product.branchesId.contains("\(branchId)") {
                if Defaults.sharedInstance.cartId == "\(branchId)" {
                    LocalDataManager.sharedInstance.addLikeProductsToCoreData(productsList: product, .cart)
                } else {
                    LocalDataManager.sharedInstance.deleteAllData(.cart)
                    LocalDataManager.sharedInstance.addLikeProductsToCoreData(productsList: product, .cart)
                    Defaults.sharedInstance.cartId = "\(branchId)"
                }
                isAddedToCart.toggle()
                
                updateCartButton()
            } else {
                showAlertDelegate?.showInCorrectBranchAlert()
            }
        }

        
        // Update the cart button based on the product's cart status
        private func updateCartButton() {
            let cartImage: UIImage = isAddedToCart ? .decreaseButton : .addButton
            addToCartButton.setImage(cartImage, for: .normal)
        }
        
//        func SomeThingWentWrong(msg: String, btnTitle: String) {
//            CustomAlertViewController().show("Warning", "\(msg)", buttonTitle: "\(btnTitle)", .redColor, .warning)
//        }
    }

    protocol CoreDataDelegation {
        func reloadDataAfterDelete(_ type: CoreDataProductType)
    }

    protocol AddToCartAlerts {
        func showInCorrectBranchAlert()
    }


