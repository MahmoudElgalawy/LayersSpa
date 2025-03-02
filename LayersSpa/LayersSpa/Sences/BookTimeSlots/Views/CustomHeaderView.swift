//
//  CustomHeaderView.swift
//  LayersSpa
//
//  Created by 2B on 31/07/2024.
//

import Foundation
import UIKit
import UILayerSpa

class CustomHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CustomHeaderView"

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .B3Bold
        label.textColor = .darkTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
