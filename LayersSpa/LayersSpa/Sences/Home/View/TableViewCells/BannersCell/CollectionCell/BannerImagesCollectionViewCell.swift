//
//  BannerImagesCollectionViewCell.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import UIKit
import UILayerSpa

class BannerImagesCollectionViewCell: UICollectionViewCell, IdentifiableView {

    @IBOutlet weak var bannerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(radius: 14)
    }
    
    func configureCell(_ bannerImage: UIImage) {
        self.bannerImage.image = bannerImage
    }

}
