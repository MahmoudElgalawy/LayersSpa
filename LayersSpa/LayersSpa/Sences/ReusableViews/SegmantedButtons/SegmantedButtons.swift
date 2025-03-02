//
//  SegmantedButtons.swift
//  LayersSpa
//
//  Created by marwa on 25/07/2024.
//

import UIKit
import UILayerSpa

class SegmantedButtons: UIViewFromNib {

    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet  weak var secondButton: UIButton!
    @IBOutlet  weak var firstButton: UIButton!
    
    var delegate: SegmantedButtonsDelegation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerStackView.roundCorners(radius: 16)
        bindFirstButton()
        bindSecondButton()
        firstButton.applyButtonStyle(.selectedSegmentedControl)
        secondButton.applyButtonStyle(.unSelectedSegmentedControl)
    }
    
    private func bindFirstButton() {
        firstButton.applyButtonStyle(.selectedSegmentedControl)
        firstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
    }
    
    private func bindSecondButton() {
        secondButton.applyButtonStyle(.unSelectedSegmentedControl)
        secondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
    }
    
    func updateButtonsTitles(_ firstTitle: String, _ secondTitles: String) {
        firstButton.setTitle(firstTitle, for: .normal)
        secondButton.setTitle(secondTitles, for: .normal)
    }
    
    @objc func firstButtonTapped() {
        firstButton.applyButtonStyle(.selectedSegmentedControl)
        secondButton.applyButtonStyle(.unSelectedSegmentedControl)
        delegate?.firstButtonTapped()
    }
    
    @objc func secondButtonTapped() {
        firstButton.applyButtonStyle(.unSelectedSegmentedControl)
        secondButton.applyButtonStyle(.selectedSegmentedControl)
        delegate?.secondButtonTapped()
    }
}

protocol SegmantedButtonsDelegation {
    func firstButtonTapped()
    func secondButtonTapped()
}
