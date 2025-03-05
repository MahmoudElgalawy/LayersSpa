//
//  CustomDateAlertViewController.swift
//  LayersSpa
//
//  Created by marwa on 29/07/2024.
//

import Foundation
import UIKit

class CustomDateAlertViewController: UIViewController, CustomAlertDelegate {
 
    private let datePicker = UIDatePicker()
    private let selectButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    var delegate: CustomDateAlertViewControllerDelegation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Background color with transparency
        
        // Create container view
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Set constraints for the container view
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320),
            containerView.heightAnchor.constraint(equalToConstant: 380)
        ])
        
        // Configure date picker
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.minimumDate = Date()
        datePicker.tintColor = .primaryColor
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.locale = Locale(identifier: "en_US")
        containerView.addSubview(datePicker)
        
        // Set constraints for date picker
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        // Configure buttons
        selectButton.setTitle(String(localized: "select"), for: .normal)
        selectButton.tintColor = .primaryColor
        selectButton.titleLabel?.font = .B1Bold
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(selectButton)
        
        cancelButton.setTitle(String(localized: "cancel"), for: .normal)
        cancelButton.tintColor = .primaryColor
        cancelButton.titleLabel?.font = .B1Bold
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(cancelButton)
        
        // Set constraints for buttons
        NSLayoutConstraint.activate([
            selectButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            selectButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            selectButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -10),
            
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 10),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }

    @objc private func selectButtonTapped() {
        let selectedDate = datePicker.date
           print("Selected Date: \(selectedDate)")  // طباعة التاريخ بعد اختياره من الـ datePicker
           
           // تنسيق التاريخ بصيغته الأصلية
           let formattedDate = formatDate(datePicker.date)
           UserDefaults.standard.set(formattedDate, forKey: "selectedDate")
           print("Date saved to UserDefaults: \(formattedDate)")
           
           delegate?.updateSelectionDate(formattedDate)  // تمرير التاريخ إلى الـ delegate
           dismiss(animated: true, completion: nil)  // إغلاق الـ alert
    }

    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "d-M-yyyy"
        return dateFormatter.string(from: date)
    }
    func showSelectOtherAlert() {
        let alertVC = CustomAlertViewController()
        alertVC.alertDelegate = self
        alertVC.show(String(localized: "warning"), String(localized: "layersSpaIsClosedOnFriday") + ".", buttonTitle:  String(localized: "chooseAnotherDay"), navigateButtonTitle: "", .redColor, .warning, flag: true)
        present(alertVC, animated: true, completion: nil)
    }
    
    func alertButtonClicked() {
        datePicker.becomeFirstResponder()
    }

}

protocol CustomDateAlertViewControllerDelegation {
    func updateSelectionDate(_ date: String)
}
