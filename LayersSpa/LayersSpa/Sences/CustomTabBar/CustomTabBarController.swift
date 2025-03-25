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
    
    private var isRTL: Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    weak var tabBarDelegate: UITabBarControllerDelegate?
    
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
        tabBarDelegate = self
        delegate = tabBarDelegate
        setupTabBarUI()
        setupColoredView()
        adjustLayoutForCurrentLanguage()
       ///\ selectedIndex = isRTL ? (viewControllers?.count ?? 1) - 1 : 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupViewControllersBasedOnLanguage()
        
        DispatchQueue.main.async {
            if Defaults.sharedInstance.getIsNavigateToAppoinment() {
                self.selectedIndex = self.isRTL ? 3 : 1
                Defaults.sharedInstance.navigateToAppoinment(false)
            } else {
                let lastSelectedIndex = UserDefaults.standard.integer(forKey: "lastSelectedTabIndex")
                    self.selectedIndex = lastSelectedIndex
                
            }
        }
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//        setupViewControllersBasedOnLanguage()
//        let lastSelectedIndex = UserDefaults.standard.integer(forKey: "lastSelectedTabIndex")
//        self.selectedIndex = lastSelectedIndex
//    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateColoredViewPosition(animated: true)
        UserDefaults.standard.set(selectedIndex, forKey: "lastSelectedTabIndex")
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        coloredView.removeFromSuperview()
//        self.viewControllers?.forEach { $0.removeFromParent() }
//        self.viewControllers = nil
//    }
    
    // MARK: - Layout Adjustments
    
    private func adjustLayoutForCurrentLanguage() {
        tabBar.semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
    }
    
    private func setupViewControllersBasedOnLanguage() {
        let home = bindHomeViewController()
        let gallery = bindGalleryViewController() // Added
        let appointments = bindAppointmentsViewController()
        let cart = bindCartViewController()
        let myAccount = bindMyAccountViewController()
        
        var controllers: [UIViewController]
        
        if isRTL {
            controllers = [myAccount, cart,gallery, appointments, home] // Modified
        } else {
            controllers = [home, appointments, gallery, cart, myAccount] // Modified
        }
        
        self.viewControllers = controllers
    }
    
    // MARK: - Colored View Positioning
    
    private func updateColoredViewPosition(animated: Bool) {
        guard let items = tabBar.items, let selectedItem = tabBar.selectedItem, let index = items.firstIndex(of: selectedItem) else { return }
        
        let totalItems = CGFloat(items.count)
        let itemWidth = tabBar.bounds.width / totalItems
        let xPosition = isRTL ? tabBar.bounds.width - (itemWidth * (CGFloat(index) + 1)) : itemWidth * CGFloat(index)
        
        let coloredViewWidth: CGFloat = 60
        let coloredViewHeight: CGFloat = 40
        let yPosition = tabBar.bounds.height - coloredViewHeight - 31
        let coloredViewFrame = CGRect(
            x: xPosition + (itemWidth - coloredViewWidth)/2,
            y: yPosition,
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
    
    // MARK: - TabBar Setup
    
    private func setupTabBarUI() {
        tabBar.backgroundColor = .white
        tabBar.layer.cornerRadius = 30
        tabBar.tintColor = .blackColor
        tabBar.unselectedItemTintColor = .unselectedIcon
    }
    
    private func setupColoredView() {
        coloredView.backgroundColor = .grayLight
        coloredView.layer.cornerRadius = 15
        tabBar.addSubview(coloredView)
        tabBar.sendSubviewToBack(coloredView)
    }
    
    // MARK: - View Controllers Binding
    
    private func createTabItem(image: UIImage, rtlImage: UIImage) -> UITabBarItem {
        let iconImage = isRTL ? rtlImage : image
        return UITabBarItem(title: "", image: iconImage.withRenderingMode(.alwaysOriginal), selectedImage: iconImage.withRenderingMode(.alwaysOriginal))
    }
    
    // MARK: - Delegate Methods
//    
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        updateColoredViewPosition(animated: true)
//    }
    
    
    private func bindHomeViewController() -> UIViewController {
        let vc = HomeViewController(viewModel: HomeViewModel())
        vc.tabBarItem = createTabItem(image: .home, rtlImage: .home)
        return vc
    }

    private func bindAppointmentsViewController() -> UIViewController {
        let vc = AppointmentsViewController(viewModel: AppointmentsViewModel())
        vc.tabBarItem = createTabItem(image: .appointment, rtlImage: .appointment)
        return vc
    }

    private func bindCartViewController() -> UIViewController {
        let vc = CartViewController(viewModel: CartViewModel())
        vc.tabBarItem = createTabItem(image: .cart, rtlImage: .cart)
        return vc
    }

    private func bindMyAccountViewController() -> UIViewController {
        let vc = MyAccountViewController(viewModel: MyAccountViewModel())
        vc.tabBarItem = createTabItem(image: .myAccount, rtlImage: .myAccount)
        return vc
    }
    
    private func bindGalleryViewController() -> UIViewController {
        let vc = GalleryViewController(viewModel: GalleryViewModel())
        vc.tabBarItem = createTabItem(image: .products, rtlImage: .products)
        return vc
    }

}




//
//override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//        setupViewControllersBasedOnLanguage()
//        resetSelectedIndex() // إضافة هذه الدالة
//    }
//    
//    private func setupViewControllersBasedOnLanguage() {
//        let home = bindHomeViewController()
//        let appointments = bindAppointmentsViewController()
//        let cart = bindCartViewController()
//        let myAccount = bindMyAccountViewController()
//        
//        var controllers: [UIViewController]
//        
//        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
//            controllers = [myAccount, cart, appointments, home]
//        } else {
//            controllers = [home, appointments, cart, myAccount]
//        }
//        
//        self.viewControllers = controllers
//        
//        // تحديد الفهرس المناسب لشاشة المواعيد حسب اللغة
//        if Defaults.sharedInstance.getIsNavigateToAppoinment() {
//            let appointmentsIndex = isRTL ? 2 : 1
//            selectedIndex = appointmentsIndex
//            Defaults.sharedInstance.setIsNavigateToAppoinment(false)
//        }
//    }
//    
//    private var isRTL: Bool {
//        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
//    }
//    
//    private func resetSelectedIndex() {
//        if !Defaults.sharedInstance.getIsNavigateToAppoinment() {
//            selectedIndex = 0 // تحديد أول تابة بشكل افتراضي
//        }
//    }
//    
//    func reloadForLanguageChange() {
//        adjustLayoutForCurrentLanguage()
//        setupViewControllersBasedOnLanguage()
//        resetSelectedIndex() // إعادة تعيين الفهرس عند تغيير اللغة
//        updateColoredViewPosition(animated: true)
//    }
//    
//    // ... بقية الأكواد بدون تغيير ...
//}
