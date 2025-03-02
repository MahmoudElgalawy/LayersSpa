//
//  ReviewTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.
//

import UIKit
import UILayerSpa

class ReviewTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starView: StarsView!
    @IBOutlet weak var customerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starView.applyStyleToView()
        starView.updateStarsRating(3.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ data: ServiceDetailVM?) {
        
    }
    
}
