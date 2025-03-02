//
//  SearchControllerExtension.swift
//  SayHi
//
//  Created by Mahmoud on 05/01/2025.
//

import Foundation
import UIKit

extension UISearchBar {
    func customizeSearchBar() {
        
        self.searchTextField.borderStyle = .none
        self.searchTextField.layer.cornerRadius = 10
        self.searchTextField.clipsToBounds = true
        self.searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.searchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        ])
        
        // cursor color
        self.searchTextField.tintColor = UIColor.black
       
        
        //  searchTextField color
        self.searchTextField.backgroundColor = UIColor.white
        self.searchTextField.textColor = UIColor.black
        
        // placeholder color and text
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray4
        ]
        let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
        self.searchTextField.attributedPlaceholder = attributedPlaceholder
        
        if let searchIcon = UIImage(systemName: "magnifyingglass") {
            let tintedImage = searchIcon.withTintColor(UIColor.systemGray2, renderingMode: .alwaysOriginal)
            self.setImage(tintedImage, for: UISearchBar.Icon.search, state: .normal)
        }
    }
}
