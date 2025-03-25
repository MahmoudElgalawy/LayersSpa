//
//  CategoriesTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import UIKit
import UILayerSpa

class CategoriesTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet private weak var arrowImage: UIImageView!
    @IBOutlet private weak var viewAllButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    
    weak var delegate: ViewAllDelegation?
    private let layout = UICollectionViewFlowLayout()
    private var categoriesInfo: [CategoriesVM] = []
    
    override func layoutSubviews() {
        collectionViewSetup()
        collectionViewLayout()
        bindViewAllButton()
        selectionStyle = .none
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        arrowImage.image = nil
        categoriesInfo.removeAll()
        categoriesCollectionView.reloadData()
    }
    
    func configeCell(_ categories:  [CategoriesVM]) {
        categoriesInfo = categories
        titleLabel.text = String(localized: "categories")
        viewAllButton.setTitle(String(localized: "viewAll"), for: .normal)
        rotateImageBasedOnLanguage()
        categoriesCollectionView.reloadData()
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            arrowImage.image = nil
        }
    }
    
    func rotateImageBasedOnLanguage() {
        let currentLanguage = Locale.preferredLanguages.first ?? "en"
        let rotationAngle: CGFloat = currentLanguage == "ar" ? .pi : 0
        arrowImage.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    func bindViewAllButton() {
        viewAllButton.removeTarget(nil, action: nil, for: .allEvents) // إزالة جميع الأوامر السابقة
        viewAllButton.addTarget(self, action: #selector(navigateToCategories), for: .touchUpInside)
    }

    func collectionViewSetup() {
        let nib = UINib(nibName: "CategoriesCollectionViewCell", bundle: nil)
        categoriesCollectionView.register(nib, forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
    }

    
    func collectionViewLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8 // Space between columns
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // Padding around the section
        categoriesCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        categoriesCollectionView.collectionViewLayout = layout
    }

}

extension CategoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoriesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(categoriesInfo[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categoriesInfo[indexPath.row]
        delegate?.navigateToCategoryServices(category.title, category.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width: CGFloat = 104
        return CGSize(width: width, height: height)
    }
    
}

extension CategoriesTableViewCell {
    @objc func navigateToCategories() {
        delegate?.navigateToCategories()
    }
}


