//
//  HomeTopView.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import UIKit
import UILayerSpa
import Combine

class HomeTopView: UIViewFromNib {

    @IBOutlet weak var selectBranchStackView: UIStackView!
    @IBOutlet private(set) weak var searchTextField: UITextField!
    @IBOutlet private(set) weak var searchView: UIView!
    @IBOutlet private(set) weak var notificationButton: UIButton!
    @IBOutlet private(set) weak var branchNameLabel: UILabel!
    @IBOutlet private(set) weak var branchTitleLabel: UILabel!
    @IBOutlet private(set) weak var wishListButton: UIButton!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var viewBak: UIView!
    
    var delegate: HomeTopViewDelegation?
    private var cancellables = Set<AnyCancellable>()
    var searchTextSubject = PassthroughSubject<String, Never>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // bindNotificationButton()
        setBranchTitleLabel()
        setBranchNameLabel()
        bindLikesButton()
        bindSelectBranchStackView()
        bindSearchView()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedfav"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadWish), name:  Notification.Name("chandedunfav"), object: nil)
    }
    
    @objc func reloadWish(){
        favCount.text = "\(LocalDataManager.sharedInstance.getCounter())"
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("chandedfav"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("chandedunfav"), object: nil)
    }
    
}

extension HomeTopView {
    
    func updateBranchName(_ branchName: String) {
        DispatchQueue.main.async {
            self.branchNameLabel.text = branchName
        }
    }
    
    private func setBranchTitleLabel() {
        branchTitleLabel.text = String(localized: "branch")
    }
    
    private func setBranchNameLabel() {
        branchNameLabel.text = String(localized: "allBranches")
    }
//
//    private func bindNotificationButton() {
//        notificationButton.roundCorners(radius: 16)
//        notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
//    }

    private func bindLikesButton() {
        viewBak.roundCorners(radius: 16)
        wishListButton.addTarget(self, action: #selector(likesTapped), for: .touchUpInside)
        favCount.text = "\(LocalDataManager.sharedInstance.getCounter())"
    }

    @objc func notificationTapped() {
        delegate?.navigateToNotification() // الانتقال إلى التنبيهات
    }

    @objc func likesTapped() {
        delegate?.navigateToLikes() // الانتقال إلى المفضلة
    }

    
    
}

extension HomeTopView {
    func bindSelectBranchStackView() {
        selectBranchStackView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectBranchTapped))
        selectBranchStackView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func SelectBranchTapped() {
        delegate?.showBranchSelection()
    }
}

extension HomeTopView {
    
    func bindSearchView() {
           searchTextField.placeholder = String(localized: "search")
           searchTextField.font = .B2Medium
           searchView.roundCorners(radius: 16)
           
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchViewTapped))
        searchTextField.addGestureRecognizer(tapGesture)
        searchTextField.isUserInteractionEnabled = true
       }
    
    @objc func searchViewTapped() {
            delegate?.navigateToSearch()
        }

}

protocol HomeTopViewDelegation {
    func navigateToLikes()
    func navigateToNotification()
    func navigateToSearch()
    func showBranchSelection()
}
