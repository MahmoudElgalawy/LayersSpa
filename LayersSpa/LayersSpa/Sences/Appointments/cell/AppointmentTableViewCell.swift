//
//  AppointmentTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 27/07/2024.
//

import UIKit
import UILayerSpa

class AppointmentTableViewCell: UITableViewCell, IdentifiableView {

    @IBOutlet private weak var containerVIew: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet private weak var cartDetailsLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
//    @IBOutlet private weak var stateImage: UIImageView!
    var branches = [BrancheVM]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerVIew.roundCorners(radius: 16)
        if let savedData = UserDefaults.standard.data(forKey: "Branches"),
           let decodedBranches = try? JSONDecoder().decode([BrancheVM].self, from: savedData) {
            self.branches = decodedBranches
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(_ appointment: Calender,_ order: Order) {
            for branch in branches{
                if appointment.branchID == branch.id{
                    locationLabel.text = branch.name
                    break
                }
            }
        
        let dateAndTime = appointment.start?.split(separator: " ")
        let serviceCount = appointment.items.count
        
        dateLabel.text = "\((dateAndTime?[0])!)"
        timeLabel.text = "\((dateAndTime?[1])!)"
        idLabel.text = "\((appointment.reservationCode)!)"
        cartDetailsLabel.text = "\(order.service) services / \(order.product) products"
        priceLabel.text = "\(order.total)"
    }
    
}

//struct AppointmentsVM {
//    let stateImage: UIImage
//    let stateTitle: String
//    let location: String
//    let date: String
//    let time: String
//    let price: String
//    let cartDetails: String
//    let id: String
//}
