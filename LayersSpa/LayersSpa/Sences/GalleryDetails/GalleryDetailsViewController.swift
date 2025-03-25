//
//  GalleryDetailsViewController.swift
//  LayersSpa
//
//  Created by Marwa on 04/09/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class GalleryDetailsViewController: UIViewController, CustomAlertDelegate {
   
    var pageImage: String?

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var saveImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindBackButton()
        bindViewButton()
        bindLoginButton()
        setupBackgroundView()
//        if let pageImage = pageImage {
//            print("image get")
//            imageView.kf.setImage(with: URL(string:pageImage))
//        }else {
//            print("nil")
//        }
        imageView.image = UIImage(named: "backgroundOnBoarding2")
    }
    
    private func setupBackgroundView() {
     //   backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func bindBackButton() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    func bindLoginButton() {
        //loginButton.setTitle("Sign in", for: .normal)
        saveImage.applyButtonStyle(.filled)
        saveImage.applyButtonStyle(.plain)
        saveImage.backgroundColor = .secondary
        saveImage.setTitle(String(localized: "saveImage"), for: .normal)
    }
    
    private func bindViewButton() {
       // viewButton.applyButtonStyle(.filled)
     //   viewButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveImageBtn(_ sender: Any) {
        
        guard let image = imageView.image else {
            showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "nophoto"), buttonTitle: String(localized:"ok"), image: .warning)
              return
          }
          
          UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    @objc func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: String(localized: "warning") + "!!", msg: String(localized: "failedsave"), buttonTitle: String(localized:"ok"), image: .warning)
        } else {
            showAlert(title: String(localized: "successfulStep"), msg: String(localized: "saveddone"), buttonTitle: String(localized: "ok"), image: .alert)
        }
    }
    
    
    func showAlert(title: String, msg: String, buttonTitle: String, image: UIImage) {
        let alert = CustomAlertViewController()
        alert.alertDelegate = self
        alert.show(title, msg, buttonTitle: buttonTitle, navigateButtonTitle: "", .redColor, image, flag: true)
    }
    
    func alertButtonClicked() {
        
    }
    
}
