//
//  DateFooterView.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import UIKit
import UILayerSpa

class DateFooterView: UIViewFromNib {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: DateFooterViewDelegation?
    let datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyStyle()
        bindCalenderButton()
    }
    
    func applyStyle() {
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.border.cgColor
        containerView.layer.borderWidth = 1
        titleLabel.textColor = UIColor.darkTextColor
        dateLabel.textColor = UIColor.darkTextColor
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "d-M-yyyy"
//        dateLabel.text =  dateFormatter.string(from: Date())
    }
    
    func bindCalenderButton() {
        calenderButton.addTarget(self, action: #selector(calenderTapped), for: .touchUpInside)
    }
    
    @objc func calenderTapped() {
        delegate?.showDatePicker()
       // datePicker.isHidden = false
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
           let selectedDate = sender.date
           dateSelected(date: selectedDate)
       }
       
       func dateSelected(date: Date) {
           // Handle the selected date
           print("Selected Date: \(date)")
       }

}

protocol DateFooterViewDelegation {
    func showDatePicker()
}
