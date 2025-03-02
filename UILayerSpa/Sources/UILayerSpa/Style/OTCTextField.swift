//
//  File.swift
//  
//
//  Created by marwa on 13/06/2024.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
public class OTCTextField: UITextField {

    public var didEnterLastDigit: ((String) -> Void)?
    var defaultCharacter = ""
    private var isConfigured = false
    private var digitsLabels: [UILabel] = []
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()

    public func configure(with slotCount: Int = 6) {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()
        let labelsStackView = createLabelStackView(with: slotCount)
        addSubview(labelsStackView)
        addGestureRecognizer(tapRecognizer)
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }

    private func createLabelStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        (1 ... count).forEach { _ in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .h2Bold
            label.text = defaultCharacter
            label.layer.borderColor = UIColor.primaryColor.cgColor
            label.layer.borderWidth = 2
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 12
            stackView.addArrangedSubview(label)

            digitsLabels.append(label)
        }

        return stackView
    }

    @objc private func textDidChange() {
        guard let text = text, text.count <= digitsLabels.count else { return }
        for i in 0 ..< digitsLabels.count {
            let currentLabel = digitsLabels[i]

            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text = String(text[index])
            } else {
                currentLabel.text = defaultCharacter
            }
        }

        if text.count == digitsLabels.count {
            didEnterLastDigit?(text)
        }
    }
}

// MARK: - UITextFieldDelegate

@available(iOS 12.0, *)
extension OTCTextField: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let charachterCount = textField.text?.count else { return false }
        return charachterCount < digitsLabels.count || string == ""
    }
}
