//
//  GalleryDetailsViewController.swift
//  LayersSpa
//
//  Created by Marwa on 04/09/2024.
//

import UIKit
import UILayerSpa

class GalleryDetailsViewController: UIViewController {
    var pageImage: UIImage?

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindBackButton()
        bindViewButton()
        setupBackgroundView()
        if let pageImage = pageImage {
            print("image get")
            imageView.image = pageImage
        }else {
            print("nil")
        }
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func bindBackButton() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    private func bindViewButton() {
        viewButton.applyButtonStyle(.filled)
     //   viewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
