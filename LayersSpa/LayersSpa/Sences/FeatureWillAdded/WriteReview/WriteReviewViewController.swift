//
//  WriteReviewViewController.swift
//  LayersSpa
//
//  Created by marwa on 12/08/2024.
//

import UIKit
import UILayerSpa

class WriteReviewViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var confitmButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var textViewTitleLabel: UILabel!
    @IBOutlet weak var starView: StarsView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cloaseButton: UIButton!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        bindCloseBtn()
        starView.applyEditableStyleToView()
        bindConfirmButton()
        bindTextContainerView()
    }
    
    func show() {

        guard let window = UIApplication.shared.currentWindow else {
            print("No current window found")
            return
        }
        guard let rootViewController = window.rootViewController else {
            print("No root view controller found")
            return
        }
        rootViewController.present(self, animated: true, completion: nil)
    }


}


extension WriteReviewViewController {
    
    func applyStyle() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        containerView.roundCorners(radius: 24)
        
    }
    
    
    func bindCloseBtn() {
        cloaseButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }
    
    func bindConfirmButton() {
        confitmButton.applyButtonStyle(.filled)
        confitmButton.setTitle("Confirm", for: .normal)
        confitmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        
    }
    
    func bindTextContainerView() {
        textContainerView.layer.borderColor = UIColor.border.cgColor
        textContainerView.layer.borderWidth = 1
        textContainerView.roundCorners(radius: 16)
    }
    
    
}
