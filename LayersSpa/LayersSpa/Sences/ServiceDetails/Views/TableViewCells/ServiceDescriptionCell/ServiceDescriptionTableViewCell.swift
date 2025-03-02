//
//  ServiceDescriptionTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.
//

import UIKit
import UILayerSpa

class ServiceDescriptionTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var delegate: ServiceDetailsDelegation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindReadMoreBtn()
        //bindViewAllBtn()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ data: ServiceDetailVM?) {
        titleLabel.text = data?.description ?? ""
    }
    
    func bindReadMoreBtn() {
        readMoreButton.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)
    }
    
    @objc func readMoreTapped() {
        delegate?.readMoreDescription()
    }
    
//    func bindViewAllBtn() {
//        viewAllButton.addTarget(self, action: #selector(viewAllTapped), for: .touchUpInside)
//    }
    
//    @objc func viewAllTapped() {
//     //   delegate?.viewAllReviews()
//    }
    
}

protocol ServiceDetailsDelegation {
    func readMoreDescription()
   // func viewAllReviews()
    //func writeReviews()
    func didSelectService(_ service: ProductVM)
}
