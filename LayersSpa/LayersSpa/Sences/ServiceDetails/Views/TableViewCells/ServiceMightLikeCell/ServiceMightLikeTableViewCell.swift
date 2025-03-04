//
//  ServiceMightLikeTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.
//

import UIKit
import UILayerSpa

class ServiceMightLikeTableViewCell: UITableViewCell, IdentifiableView, CustomAlertDelegate, AddToCartAlerts {

    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var writeReviewButton: UIButton!
    @IBOutlet weak var youMightAlsoLikeLabel: UILabel!
    var delegate: ServiceDetailsDelegation?
    private let layout = UICollectionViewFlowLayout()

    
   var servicesList: [ProductVM] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        youMightAlsoLikeLabel.text = String(localized: "youMightAlsoLike")
        collectionViewSetup()
        collectionViewLayout()
        bindWriteReviewButton()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedfav"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedunfav"), object: nil)
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func reloadWish(){
        servicesCollectionView.reloadData()
    }
    
    func collectionViewSetup() {
        servicesCollectionView.register(ProductAndServiceCollectionViewCell.self)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
    }
    
    func collectionViewLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        servicesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        servicesCollectionView.collectionViewLayout = layout
    }
    
    func bindWriteReviewButton() {
        writeReviewButton.isHidden = true
        writeReviewButton.titleLabel?.font = .B3Bold
        writeReviewButton.layer.borderColor = UIColor.primaryColor.cgColor
        writeReviewButton.layer.borderWidth = 1
        writeReviewButton.roundCorners(radius: 20)
        writeReviewButton.setTitleColor(.primaryColor, for: .normal)
        writeReviewButton.setTitle("Write Review", for: .normal)
        writeReviewButton.addTarget(self, action: #selector(writeReviewTapped), for: .touchUpInside)
    }
    
    @objc func writeReviewTapped() {
       // delegate?.writeReviews()
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }

}

extension ServiceMightLikeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductAndServiceCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.showAlertDelegate = self
            cell.configureCellForService(servicesList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = servicesList.count
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = ServiceDetailsViewController(viewModel: ServiceDetailsViewModel())
//        vc.serviceId = self.servicesList[indexPath.row].productId
//        vc.product = servicesList[indexPath.row]
//            vc.isProduct = false
//        self.navigationController?.pushViewController(vc, animated: true)
        let selectedService = servicesList[indexPath.row]
            delegate?.didSelectService(selectedService)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width: CGFloat = 148
        return CGSize(width: width, height: height)
    }
    
    func showInCorrectBranchAlert() {
        let alert =  CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(String(localized: "warning"), String(localized: "selectABranchMSG"), buttonTitle: String(localized: "navigateToHome"), navigateButtonTitle: String(localized: "cancel"), .redColor, .warning, flag: false)
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

