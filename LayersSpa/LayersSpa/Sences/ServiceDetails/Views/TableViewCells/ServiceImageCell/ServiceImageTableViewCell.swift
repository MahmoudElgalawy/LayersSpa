//
//  ServiceImageTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class ServiceImageTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var totalReviewsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewView: StarsView!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reviewView.applyStyleToView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ data: ServiceDetailVM?) {
        totalReviewsLabel.text = "(\(String(localized: "from")) \(data?.totalReviews ?? 0) \(String(localized: "reviews")))"
        ratingLabel.text = "\(data?.rating ?? 0.0)"
        reviewView.updateStarsRating(Double(data?.rating ?? 0.0))
        servicePrice.text = "\(data?.price ?? "0")"
        serviceTitleLabel.text = "\(data?.serviceName ?? "Product Name")"
        let url = URL(string: data?.serviceImage ?? "")
        serviceImage.kf.setImage(with: url, placeholder: UIImage.placeHolder)
    }
}
