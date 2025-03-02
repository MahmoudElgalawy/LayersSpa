//
//  CartTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 28/07/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class CartTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var profInfoStackView: UIStackView!
    @IBOutlet weak var counterStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var serviceNameLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var decreaseButton: UIButton!
    @IBOutlet private weak var increaseButton: UIButton!
    @IBOutlet  weak var deleteButton: UIButton!
    @IBOutlet weak var timeImg: UIImageView!
    
    
    var cellProduct: ProductVM?
    var delegate: CartDelegation?
    var productCount = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: 16)
        bindDeleteButton()
        bindDecreaseButton()
        bindIncreaseButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ isFromCart: Bool, cartProduct: ProductVM) {
        
        if isFromCart {
            counterStackView.isHidden = false
            profInfoStackView.isHidden = true
        } else {
            counterStackView.isHidden = true
            if cartProduct.isService {
                profInfoStackView.isHidden = false
            }else {
                profInfoStackView.isHidden = true
            }
           
        }
        
        if cartProduct.type != "service" {
            timeImg.image = UIImage(named: "notif1")
            durationLabel.text = "\(cartProduct.productCount)"
        } else {
            timeImg.image = UIImage(named: "time")
            durationLabel.text = "\(((cartProduct.unit)! * cartProduct.productCount)) m"
        }
        
        cellProduct = cartProduct
        productCount = cartProduct.productCount
        serviceNameLabel.text = cartProduct.productName
        let url = URL(string: cartProduct.productImage)
        productImage.kf.setImage(with: url)
        let price = ((Double(cartProduct.productPrice) ?? 0) * Double(cartProduct.productCount))
        priceLabel.text = "\(price)"
        countLabel.text = "\(cartProduct.productCount)"
      //  durationLabel.text = "\(cartProduct.unit ?? 30)"
    }
    
}

extension CartTableViewCell {
    
    func bindDeleteButton() {
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    func bindIncreaseButton() {
        increaseButton.addTarget(self, action: #selector(increaseTapped), for: .touchUpInside)
    }
    
    func bindDecreaseButton() {
        decreaseButton.addTarget(self, action: #selector(decreaseTapped), for: .touchUpInside)
    }
    
    @objc func deleteTapped() {
        if let cellProduct = cellProduct {
            LocalDataManager.sharedInstance.deleteProduct(cellProduct.productId, .cart) { [weak self] result in
                guard let self = self else { return }
                if result {
                    self.delegate?.deleteCartProduct()
                } else {
                    print("faild")
                }
            }
        }
    }
    
    @objc func increaseTapped() {
        productCount += 1
        countLabel.text = "\(productCount)"
        if var cellProduct = cellProduct {
            cellProduct.productCount = productCount
            LocalDataManager.sharedInstance.updateProductsListInCoreData(cellProduct, .cart)
            self.delegate?.deleteCartProduct()
        }
    }
    
    @objc func decreaseTapped() {
        if productCount > 1 {
            productCount -= 1
            countLabel.text = "\(productCount)"
            if var cellProduct = cellProduct {
                cellProduct.productCount = productCount
                LocalDataManager.sharedInstance.updateProductsListInCoreData(cellProduct, .cart)
                self.delegate?.deleteCartProduct()
            }
        } else if productCount == 1 {
            productCount -= 1
            countLabel.text = "\(productCount)"
            if let cellProduct = cellProduct {
                LocalDataManager.sharedInstance.deleteProduct(cellProduct.productId, .cart) { [weak self] result in
                    guard let self = self else { return }
                    if result {
                        self.delegate?.deleteCartProduct()
                    } else {
                        print("Failed to delete product from cart")
                    }
                }
            }
        }
    }
}

protocol CartDelegation {
    func deleteCartProduct()
}
