//  
//  MyAccountViewController.swift
//  LayersSpa
//
//  Created by marwa on 20/07/2024.
//

import UIKit
import UILayerSpa
import Kingfisher

class MyAccountViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userImageView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: Properties

    private var viewModel: MyAccountViewModelType
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .primaryColor
        indicator.hidesWhenStopped = true
        return indicator
    }()


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
        if UserDefaults.standard.bool(forKey: "guest"){
            
        }else{
            setupActivityIndicator()
            activityIndicator.startAnimating()
        }
        bindViewStyle()
        tableViewSetup()
        
        viewModel.onUserProfileFetched = { [weak self] user in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.activityIndicator.startAnimating() // ✅ تشغيل المؤشر قبل تحميل الصورة
                
                if let user = user {
                    self.userName.text = "\(user.firstName) \(user.lastName ?? "")"
                    self.userPhoneNumber.text = "\(user.phone)"
                    
                    if let imgURL = URL(string: "\(user.image)") {
                        self.userImage.kf.setImage(with: imgURL, placeholder: UIImage(named: "Avatar1"), options: nil, progressBlock: nil) { result in
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating() // ✅ إيقاف المؤشر بعد تحميل الصورة
                            }
                        }
                    } else {
                        self.activityIndicator.stopAnimating() // ✅ إيقافه في حالة وجود خطأ
                    }
                    
                    Defaults.sharedInstance.userData?.name = "\(user.firstName) \(user.lastName ?? "")"
                    Defaults.sharedInstance.userData?.email = user.email
                } else {
                    self.activityIndicator.stopAnimating() // ✅ إيقافه في حالة عدم وجود بيانات
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if !UserDefaults.standard.bool(forKey: "guest") {
            viewModel.fetchUserProfile()
        }
    }
}

// MARK: - Actions

extension MyAccountViewController {}

// MARK: - Configurations

extension MyAccountViewController {
    
    func bindViewStyle() {
        userImage.roundCorners(radius: 39)
        userImageView.roundCorners(radius: 40)
        backgroundImage.roundBottomCorners(radius: 24)
        accountTableView.roundCorners(radius: 16)
    }
    
    func tableViewSetup() {
        accountTableView.register(AccountTableViewCell.self)
        accountTableView.delegate = self
        accountTableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate

extension MyAccountViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        switch indexPath.row {
//        case 0:
//            let vc = MyProfileViewController(viewModel: MyAccountViewModel())
//            navigationController?.pushViewController(vc, animated: true)
//        case 1:
//            let vc = WalletViewController(viewModel: WalletViewModel())
//            navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            let vc = SettingViewController(viewModel: SettingViewModel())
//            navigationController?.pushViewController(vc, animated: true)
//        case 3:
//            let vc = AboutLayersViewController(viewModel: AboutLayersViewModel())
//            navigationController?.pushViewController(vc, animated: true)
//        case 4:
//            let vc = TermsOfUseViewController(viewModel: TermsOfUseViewModel())
//            navigationController?.pushViewController(vc, animated: true)
//        case 5:
//            let vc = PrivacyPolicyViewController(viewModel: PrivacyPolicyViewModel())
//            navigationController?.pushViewController(vc, animated: true)
//        case 6:
//            let alertVC = CustomAlertViewController()
//            alertVC.show("Warning", "You are about to sign out", buttonTitle: "Sign Out",navigateButtonTitle: "Cancel", .redColor, .warning, flag: false)
//            alertVC.alertDelegate = self
//        default:
//            print("Default")
//        }
        switch indexPath.row {
        case 0:
            let vc = MyProfileViewController(viewModel: MyAccountViewModel())
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = SettingViewController(viewModel: SettingViewModel())
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = WalletViewController(viewModel: WalletViewModel())
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            if UserDefaults.standard.bool(forKey: "guest"){
                if let navController = self.navigationController {
                    for controller in navController.viewControllers {
                        if controller is LoginViewController{ 
                            navController.popToViewController(controller, animated: true)
                            return
                        }
                    }
                }
            }else{
                let alertVC = CustomAlertViewController()
                alertVC.show(String(localized: "warning") + "!", String(localized: "youAreAboutToSignOut"), buttonTitle: String(localized: "signOut"),navigateButtonTitle: String(localized: "cancel"), .redColor, .warning, flag: false)
                alertVC.alertDelegate = self
            }
        default:
            print("Default")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource

extension MyAccountViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCellsNum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell: AccountTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configeCell(viewModel.getAccountCellInfo(indexPath.row))
        if indexPath.row == 6 {
            cell.clearLineView()
        }
        return cell
    }
    
}





// MARK: - Private Handlers

extension MyAccountViewController: CustomAlertDelegate {
    func alertButtonClicked() {
        self.clearStoredData()
        Defaults.sharedInstance.logout()
        let vc = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.setViewControllers([vc], animated: true)
        
    }
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    
    private func clearStoredData() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "selectedEmployeeIds")
        defaults.removeObject(forKey: "selectedServiceTime")
        defaults.synchronize()
    }
}
