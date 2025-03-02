//
//  GalleryCollectionViewCell.swift
//  LayersSpa
//
//  Created by Marwa on 04/09/2024.
//

import UIKit
import UILayerSpa

class GalleryCollectionViewCell: UICollectionViewCell, IdentifiableView {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondaryColor.cgColor
    }

}
