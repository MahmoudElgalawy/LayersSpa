//
//  SearchWithFilterAndSortView.swift
//  LayersSpa
//
//  Created by marwa on 26/07/2024.
//

import UIKit
import UILayerSpa
import Combine

class SearchWithFilterAndSortView: UIViewFromNib {
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchIcon: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    var delegate: SearchWithFilterAndSortViewDelegation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bindSearchView()
        bindSortButton()
        bindFilterButton()
    }
}

extension SearchWithFilterAndSortView {
    
    func bindSortButton() {
        sortButton.addTarget(self, action: #selector(sortTapped), for: .touchUpInside)
    }
    
    func bindFilterButton() {
        filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
    }
    
    @objc func filterTapped() {
        delegate?.showFilter()
    }
    
    @objc func sortTapped() {
        delegate?.showSort()
    }
    
    func bindSearchView () {
        searchTF.placeholder = "Search Services"
        searchTF.font = .B2Medium
        containerView.roundCorners(radius: 16)
        containerView.layer.borderColor = UIColor.border.cgColor
        containerView.layer.borderWidth = 1
    }
    
    func textDidChangeNotification() -> AnyPublisher <String, Never> {
        return NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTF)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .eraseToAnyPublisher()
    }
    
    func textDidBeginNotification() -> AnyPublisher <String, Never> {
        return NotificationCenter.default
            .publisher(for: UITextField.textDidBeginEditingNotification, object: searchTF)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
    
}

protocol SearchWithFilterAndSortViewDelegation {
    func showFilter()
    func showSort()
}

