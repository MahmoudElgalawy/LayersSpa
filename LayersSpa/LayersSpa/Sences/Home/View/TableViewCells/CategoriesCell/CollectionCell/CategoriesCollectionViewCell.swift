//
//  CategoriesCollectionViewCell.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class CategoriesCollectionViewCell: UICollectionViewCell, IdentifiableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(radius: 14)
        icon.roundCorners(radius: 14)
    }
    
    func configureCell(_ category: CategoriesVM) {
        let url = URL(string: category.icon)
        icon.kf.setImage(with: url,placeholder: UIImage(named: "products"))
        titleLabel.text = category.title
        print("Category Title ======================\(category.title)")
    }

}
