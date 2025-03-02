//
//  CustomDatePicker.swift
//  LayersSpa
//
//  Created by marwa on 28/07/2024.
//

import Foundation
import UIKit

class CustomDatePicker: UIDatePicker {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        if #available(iOS 13.4, *) {
            preferredDatePickerStyle = .inline
        }
        datePickerMode = .date
        tintColor = .primaryColor
        backgroundColor = .whiteColor
        self.roundCorners(radius: 16)
        adjustFontSize()
    }

    private func adjustFontSize() {
        // Recursively find UILabels in subviews and adjust their font size
        func adjustFont(in view: UIView) {
            for subview in view.subviews {
                if let label = subview as? UILabel {
                    label.font = .B3Medium
                } else {
                    adjustFont(in: subview)
                }
            }
        }

        adjustFont(in: self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        adjustFontSize()
    }
}
