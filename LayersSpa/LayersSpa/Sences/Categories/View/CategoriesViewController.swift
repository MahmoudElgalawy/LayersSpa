//  
//  CategoriesViewController.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import UIKit

class CategoriesViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var categoriesCollectionView: UICollectionView!
    @IBOutlet private weak var navBar: NavigationBarWithBack!
    
    // MARK: Properties

    private var viewModel: CategoriesViewModelType
    // MARK: Init

    init(viewModel: CategoriesViewModelType) {
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
       // print("Titles=================================================\(viewModel2.titles)")
        navBar.updateTitle("All Categories")
        navBar.delegate = self
        collectionViewSetup()
        bindViewModel()
    }
}

// MARK: - Actions

extension CategoriesViewController {
    func bindViewModel() {
        
        viewModel.onShowNetworkErrorAlertClosure = { [weak self] alertMessage in
            guard let self = self else { return }
            self.showError("Invalid", alertMessage)
            print(alertMessage)
        }
        
        viewModel.onReloadData = { [weak self] result in
            guard let self = self else { return }
            print("result, ", result)
            self.categoriesCollectionView.reloadData()
        }
        
        viewModel.onUpdateLoadingStatus = { [weak self] state in
            
            guard let self = self else { return }
            
            switch state {
            case .error:
                print("error")
                activityIndicator.stopAnimating()
            case .loading:
                print("loading")
                activityIndicator.startAnimating()
            case .loaded:
                print("loaded")
                activityIndicator.stopAnimating()
            case .empty:
                print("empty")
            }
        }
        
        viewModel.getCategories()
    }
    
}

// MARK: - Configurations

extension CategoriesViewController {
    
    func collectionViewSetup() {
           categoriesCollectionView.register(CategoriesCollectionViewCell.self)
           categoriesCollectionView.delegate = self
           categoriesCollectionView.dataSource = self
           collectionViewLayout()
       }
       
       func collectionViewLayout() {
//           var x = 2.2
//           let layout = UICollectionViewFlowLayout()
//           layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//           categoriesCollectionView.contentInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)
//           if UIScreen.main.bounds.size.width < 400 {
//               x = 2.4
//           }
//           layout.itemSize = CGSize(width: categoriesCollectionView.frame.width / x, height: 120.0)
//           layout.minimumLineSpacing = 12
//           layout.scrollDirection = .vertical
//           categoriesCollectionView.collectionViewLayout = layout
           let layout = UICollectionViewFlowLayout()

           // الحواف بين الأقسام
           layout.sectionInset = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)

           // عرض الشاشة
           let screenWidth = UIScreen.main.bounds.size.width

           // عدد الأعمدة
           let numberOfColumns: CGFloat = 2

           // المسافة بين العناصر
           let spacing: CGFloat = 8.0

           // عرض العنصر = (عرض الشاشة - الحواف اليسرى واليمنى - المسافات بين العناصر) / عدد الأعمدة
           let itemWidth = (screenWidth - layout.sectionInset.left - layout.sectionInset.right - (spacing * (numberOfColumns - 1))) / numberOfColumns

           // تعيين حجم العنصر
           layout.itemSize = CGSize(width: itemWidth, height: 204.0)

           // تعيين المسافات بين الأسطر
           layout.minimumLineSpacing = spacing

           // تعيين المسافات بين الأعمدة
           layout.minimumInteritemSpacing = spacing

           // الاتجاه عمودي
           layout.scrollDirection = .vertical

           categoriesCollectionView.collectionViewLayout = layout

       }
}

// MARK: - CollectionView

extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoriesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(viewModel.getCategory(indexPath.row))
        print("\(viewModel.getCategory(indexPath.row))")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getCategoriesNum()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryDetailsViewController(viewModel: CategoryDetailsViewModel())
        vc.navBarTitle = viewModel.getCategory(indexPath.row).title
        vc.categoryId = viewModel.getCategory(indexPath.row).id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}



// MARK: - Private Handlers

private extension CategoriesViewController {
    func showError(_ title: String, _ msg: String) {
        UIAlertController.Builder()
            .title(title)
            .message(msg)
            .addOkAction()
            .show(in: self)
    }
}

extension CategoriesViewController: RegistrationNavigationBarDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
