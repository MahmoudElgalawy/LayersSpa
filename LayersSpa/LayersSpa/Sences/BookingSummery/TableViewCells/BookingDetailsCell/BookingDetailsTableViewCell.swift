//
//  BookingDetailsTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 01/08/2024.
//

import UIKit
import UILayerSpa

class BookingDetailsTableViewCell: UITableViewCell, IdentifiableView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeSlotDetailsLabel: UILabel!
    @IBOutlet weak var timeSloteLabel: UILabel!
    @IBOutlet weak var dateDetailsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationDetailsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var isService = true
    override func awakeFromNib() {
        super.awakeFromNib()
    
        containerView.roundCorners(radius: 16)
        configureCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
   
    func configureCell() {
        LocalDataManager.sharedInstance.getLikeProductsListFromCoreData(.cart) { [weak self] services in
            guard let self = self else { return }
                // استرجاع البيانات من Dictionary باستخدام serviceID
                if let savedSettings = UserDefaults.standard.dictionary(forKey: "selectedServiceTime") as? [String: String] {
                    if let time = savedSettings["\((services.first?.productId)!)"] {
                        self.timeSlotDetailsLabel.text = "\((time.split(separator: "-").first)!)"
                    }
                }
        
            
            self.locationDetailsLabel.text = Defaults.sharedInstance.branchId?.name
            
            // تحويل التاريخ المخزن إلى الصيغة المطلوبة
            if let savedDate = UserDefaults.standard.string(forKey: "selectedDate") {
                let formattedDate = self.formatDateToDisplay(savedDate)
                self.dateDetailsLabel.text = formattedDate
            }
        }
    }
    
    private func formatDateToDisplay(_ savedDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-M-yyyy"  // تنسيق التاريخ المخزن في UserDefaults
        
        // تحويله إلى نوع Date
        if let date = dateFormatter.date(from: savedDate) {
            // تغيير تنسيق التاريخ عند العرض
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"  // الصيغة الجديدة المطلوبة
            return dateFormatter.string(from: date)
        }
        
        return savedDate  // في حالة فشل التحويل، إعادة القيمة الأصلية
    }
}

