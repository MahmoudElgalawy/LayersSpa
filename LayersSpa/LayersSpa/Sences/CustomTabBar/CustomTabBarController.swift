//
//  CustomTabBarController.swift
//  LayersSpa
//
//  Created by marwa on 19/07/2024.
//


import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Properties
    var coloredView = UIView()
    
    // MARK: Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabBarUI()
        setupColoredView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateColoredViewPosition(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let home = bindHomeViewController()
        let appointments = bindAppointmentsViewController()
        //let gallery = bindGalleryViewController()
        let cart = bindCartViewController()
        let myAccount = bindMyAccountViewController()
        
        let controllers = [home, appointments, cart, myAccount]
        self.viewControllers = controllers
        
        if Defaults.sharedInstance.getIsNavigateToAppoinment() {
            selectedIndex = 1
        }
    }
    
    // Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateColoredViewPosition(animated: true)
    }
    
    // MARK: - Configurations
    
    private func setupColoredView() {
        coloredView.backgroundColor = .grayLight
        coloredView.layer.cornerRadius = 15
        coloredView.clipsToBounds = true
        tabBar.addSubview(coloredView)
        tabBar.sendSubviewToBack(coloredView)
    }
    
    
    private func updateColoredViewPosition(animated: Bool) {
        guard let items = tabBar.items else { return }
        guard let selectedItem = tabBar.selectedItem else { return }
        guard let index = items.firstIndex(of: selectedItem) else { return }
        
        let itemWidth = tabBar.bounds.width / CGFloat(items.count)
        let itemFrame = CGRect(x: itemWidth * CGFloat(index), y: 0, width: itemWidth, height: tabBar.bounds.height)
        
        let coloredViewWidth: CGFloat = 60
        let coloredViewHeight: CGFloat = 40
        let coloredViewFrame = CGRect(
            x: itemFrame.midX - (coloredViewWidth / 2),
            y: tabBar.bounds.height - coloredViewHeight - 31,
            width: coloredViewWidth,
            height: coloredViewHeight
        )
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.coloredView.frame = coloredViewFrame
            }
        } else {
            self.coloredView.frame = coloredViewFrame
        }
    }
    
    
    private func setupTabBarUI() {
        
        self.tabBar.backgroundColor = UIColor.white
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.tintColor = .blackColor
        self.tabBar.unselectedItemTintColor = .unselectedIcon
        
        // Remove the line
        if #available(iOS 13.0, *) {
            let appearance = self.tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
        }
    }
    
    func bindHomeViewController() -> UIViewController {
        let item = HomeViewController(viewModel: HomeViewModel())
        item.view.backgroundColor = .grayLight
        let icon = UITabBarItem(title: "", image: .home, selectedImage: .home)
        icon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right:0)
        item.tabBarItem = icon
        return item
    }
    
    func bindMyAccountViewController() -> UIViewController {
        let item = MyAccountViewController(viewModel: MyAccountViewModel())
        item.view.backgroundColor = .grayLight
        let icon = UITabBarItem(title: "", image: .myAccount, selectedImage: .myAccount)
        icon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item.tabBarItem = icon
        return item
    }
    
    func bindCartViewController() -> UIViewController {
        let item = CartViewController(viewModel: CartViewModel())
        item.view.backgroundColor = .grayLight
        let icon = UITabBarItem(title: "", image: .cart, selectedImage: .cart)
        icon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item.tabBarItem = icon
        return item
    }
    
    func bindAppointmentsViewController() -> UIViewController {
        let item = AppointmentsViewController(viewModel: AppointmentsViewModel())
        item.view.backgroundColor = .grayLight
        let icon = UITabBarItem(title: "", image: .appointment, selectedImage: .appointment)
        icon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        item.tabBarItem = icon
        return item
    }
    
//    func bindGalleryViewController() -> UIViewController {
//        let item = GalleryViewController(viewModel: GalleryViewModel())
//        item.view.backgroundColor = .grayLight
//        let icon = UITabBarItem(title: "", image: .products, selectedImage: .products)
//        icon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        item.tabBarItem = icon
//        return item
//    }
}
