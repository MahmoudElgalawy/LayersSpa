//  
//  MyProfileViewController.swift
//  LayersSpa
//
//  Created by marwa on 04/08/2024.
//

import UIKit
import UILayerSpa
import YPImagePicker
import Photos
import Kingfisher


class MyProfileViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var phoneTF: PhoneNumberTextFieldView!
    @IBOutlet weak var phoneTitleLabel: UILabel!
   // @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var navBar: NavigationBarWithBack!
   // @IBOutlet weak var lastNametxt: UITextField!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var editButton: UIButton!
    // MARK: Properties

   // private let viewModel: MyProfileViewModelType
    private var viewModel: MyAccountViewModelType
    var selectedImage:Data?
//    private let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .large)
//        indicator.color = .primaryColor
//        indicator.hidesWhenStopped = true
//        return indicator
//    }()
    
    // MARK: Init

    init(viewModel: MyAccountViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        indicator.color = UIColor.primaryColor
        indicator.center = view.center
        viewModel.fetchUserProfile()
        viewModel.onUserProfileFetched = { [weak self] user in
                DispatchQueue.main.async {
                    self?.indicator.stopAnimating() // إيقاف الـ Indicator
                    
                    if let user = user {
                       
                        let imgURL = URL(string: "\(user.image)")
                        self?.userImage.kf.setImage(with: imgURL, placeholder: UIImage(named: "Avatar1"))

                    }
                }
            }
        navBar.delegate = self
        navBar.updateTitle("My Profile")
        bindViewStyle()
        bindLabels()
        bindTextFields()
        bindSaveButton()
        userImageView.alpha = 0.5
        if let countryCode = UserDefaults.standard.string(forKey: "CoutryCode"),
               let phoneNumber = Defaults.sharedInstance.userData?.phone {
                
                let cleanedPhone = removeCountryCode(from: phoneNumber, countryCode: countryCode)
                
            phoneTF.countryLabel.text = countryCode
            phoneTF.phoneTextField.text = cleanedPhone
            print("cleanedPhone::::::::::::::::::::::::::::::::::::::::::::::::::\(cleanedPhone)")
            }
        
        phoneTF.isUserInteractionEnabled = false
        nameTF.text = Defaults.sharedInstance.userData?.name
        emailTF.text = Defaults.sharedInstance.userData?.email
        if let editImage = UIImage(named: "selectImage")?.withRenderingMode(.alwaysTemplate) {
            editButton.setImage(editImage, for: .normal)
            editButton.tintColor = .primaryColor  // تغيير اللون إلى الأحمر
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
        }
       
    
    
    @IBAction func editPhotoBtn(_ sender: Any) {
        var config = YPImagePickerConfiguration()
          config.screens = [.library, .photo]
          config.library.mediaType = .photo
          config.showsPhotoFilters = true
          config.startOnScreen = .library
          config.library.defaultMultipleSelection = false
          config.wordings.cameraTitle = "Camera"

          let picker = YPImagePicker(configuration: config)

          picker.didFinishPicking { [unowned picker] items, cancelled in
              if cancelled {
                  print("اختيار المستخدم تم إلغاؤه")
              } else {
                  for item in items {
                      switch item {
                      case .photo(let photo):
                          print("تم اختيار صورة: \(photo.image)")
                          self.userImage.image = photo.image.circleMasked
                          
                          // تحويل الصورة إلى Data
                          if let imageData = photo.image.jpegData(compressionQuality: 0.8) {
                              self.selectedImage = imageData
                              print("تم تحويل الصورة إلى Data بنجاح!")
                          } else {
                              print("فشل في تحويل الصورة إلى بيانات")
                          }
                      case .video(_):
                          print("تم اختيار فيديو")
                      }
                  }
              }
              picker.dismiss(animated: true, completion: nil)
          }

          present(picker, animated: true, completion: nil)
    }

    
}

// MARK: - Actions

extension MyProfileViewController {}

// MARK: - Configurations

extension MyProfileViewController {
    
    func bindViewStyle() {
        userImage.roundCorners(radius: 40)
        userImageView.roundCorners(radius: 40)
        containerView.roundCorners(radius: 16)
    }
    
    func bindLabels() {
        phoneTitleLabel.applyLabelStyle(.textFieldTitleLabel)
        nameTitleLabel.applyLabelStyle(.textFieldTitleLabel)
        emailTitleLabel.applyLabelStyle(.textFieldTitleLabel)
        imageTitleLabel.applyLabelStyle(.textFieldTitleLabel)
    }
    
    func bindTextFields() {
        emailTF.applyBordertextFieldStyle("Enter your email")
        nameTF.applyBordertextFieldStyle("Enter your name")
    }
    
    func bindSaveButton() {
        saveChangesButton.setTitle("Save changes", for: .normal)
        saveChangesButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        saveChangesButton.applyButtonStyle(.filled)
    }
}

// MARK: - Private Handlers

private extension MyProfileViewController {
    @objc func saveTapped() {
        indicator.startAnimating()
        guard let email = emailTF.text, !email.isEmpty,
                  let name = nameTF.text, !name.isEmpty,
                //  let lastName = lastNametxt.text, !lastName.isEmpty,
              let countryCode = phoneTF.countryLabel.text, !countryCode.isEmpty, let phoneNumber = phoneTF.phoneTextField.text, !phoneNumber.isEmpty else {
            showEmptyState(title: "Warning", msg: "All Data Required", button: "Ok", image: .warning)
                  indicator.stopAnimating()
                return
            }
        let cleanedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
            viewModel.updateUserProfile(firstName: name, email: email, phone: "\(countryCode)\(cleanedPhoneNumber)", image: selectedImage) { [weak self] result in
                switch result {
                case .success(let message):
                    print(message)
                    DispatchQueue.main.async {
                        self?.showEmptyState(title: "Successful Step ✔️", msg: "Your Profile Updated Successfully", button: "Ok", image: .alertImage)
                        self?.indicator.stopAnimating()
                    }
                    
                case .failure(let error):
                    self?.indicator.stopAnimating()
                    print(error.localizedDescription)
                }
            }
    }
}


extension MyProfileViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func showEmptyState(title: String, msg: String,button: String,image: UIImage) {
        CustomAlertViewController().show(title, msg, buttonTitle: button,navigateButtonTitle: "", .primaryColor, image, flag: true)
    }
    
    func removeCountryCode(from phoneNumber: String, countryCode: String) -> String {
        if phoneNumber.hasPrefix(countryCode) {
            let cleanedPhone = phoneNumber.replacingOccurrences(of: countryCode, with: "")
            return cleanedPhone.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return phoneNumber
    }

}
