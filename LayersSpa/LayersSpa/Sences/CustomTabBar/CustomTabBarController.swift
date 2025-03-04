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
        adjustLayoutForCurrentLanguage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateColoredViewPosition(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupViewControllersBasedOnLanguage()
        
        print("Should navigate to appointments: \(Defaults.sharedInstance.getIsNavigateToAppoinment())")
        
        if Defaults.sharedInstance.getIsNavigateToAppoinment() {
            let appointmentsIndex = isRTL ? 2 : 1
            selectedIndex = appointmentsIndex
            Defaults.sharedInstance.navigateToAppoinment(false) // إعادة تعيين القيمة إلى false بعد الانتقال
        } else {
            selectedIndex = isRTL ? 3 : 0
        }
        
        print("Selected index: \(selectedIndex)")
    }
    
    // MARK: - Layout Adjustments
    
    private func adjustLayoutForCurrentLanguage() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            tabBar.semanticContentAttribute = .forceRightToLeft
        } else {
            tabBar.semanticContentAttribute = .forceLeftToRight
        }
    }
    
    
    private func setupViewControllersBasedOnLanguage() {
        let home = bindHomeViewController()
        let appointments = bindAppointmentsViewController()
        let cart = bindCartViewController()
        let myAccount = bindMyAccountViewController()
        
        var controllers: [UIViewController]
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            controllers = [myAccount, cart, appointments, home]
        } else {
            controllers = [home, appointments, cart, myAccount]
        }
        
        self.viewControllers = controllers
    }
    
    // MARK: - Colored View Positioning
    
    private func updateColoredViewPosition(animated: Bool) {
        guard let items = tabBar.items, !items.isEmpty else { return }
        guard let selectedItem = tabBar.selectedItem else { return }
        guard let index = items.firstIndex(of: selectedItem) else { return }
        
        let totalItems = CGFloat(items.count)
        let itemWidth = tabBar.bounds.width / totalItems
        let xPosition: CGFloat
        
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            xPosition = tabBar.bounds.width - (itemWidth * (CGFloat(index) + 1))
        } else {
            xPosition = itemWidth * CGFloat(index)
        }
        
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
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.tintColor = .blackColor
        tabBar.unselectedItemTintColor = .unselectedIcon
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
    
    private func setupColoredView() {
           coloredView.backgroundColor = .grayLight
           coloredView.layer.cornerRadius = 15
           coloredView.clipsToBounds = true
           tabBar.addSubview(coloredView)
           tabBar.sendSubviewToBack(coloredView)
       }
       
    
    // MARK: - View Controllers Binding
    
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
    
    private func createTabItem(image: UIImage, rtlImage: UIImage) -> UITabBarItem {
        let iconImage = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? rtlImage : image
        let item = UITabBarItem(title: "", image: iconImage, selectedImage: iconImage)
        item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return item
    }
    
    // MARK: - Language Change Handling
    
    func reloadForLanguageChange() {
        adjustLayoutForCurrentLanguage()
        setupViewControllersBasedOnLanguage()
        resetSelectedIndex()
        updateColoredViewPosition(animated: true)
    }
    
    // MARK: - Delegate Methods
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateColoredViewPosition(animated: true)
    }
    
    private func resetSelectedIndex() {
        if !Defaults.sharedInstance.getIsNavigateToAppoinment() {
            selectedIndex = 0 // تحديد أول تابة بشكل ي
        }
    }
    
    ////    func bindGalleryViewController() -> UIViewController {
    ////        let item = GalleryViewController(viewModel: GalleryViewModel())
    ////        item.view.backgroundColor = .grayLight
    ////        let icon = UITabBarItem(title: "", image: .products, selectedImage: .products)
    ////        icon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    ////        item.tabBarItem = icon
    ////        return item
    ////    }
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
