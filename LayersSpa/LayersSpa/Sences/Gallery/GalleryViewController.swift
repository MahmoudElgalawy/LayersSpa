//
//  GalleryViewController.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import UIKit
import Photos
import FirebaseMessaging
import Kingfisher

class GalleryViewController: UIViewController, EmptyStateDelegation {
   
    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet private weak var segmentedButtonsView: SegmantedButtons!
    @IBOutlet private weak var gallaryCollectionView: UICollectionView!
    
    @IBOutlet weak var emptyState: EmptyStateView!
    
    @IBOutlet weak var indicitor: UIActivityIndicatorView!
    
    
    // MARK: Properties
    var allPhotos: PHFetchResult<PHAsset> = PHFetchResult()
//    var layersGallery: [UIImage] = [.backgroundOnBoarding1, .backgroundOnBoarding2, .backgroundOnBoarding3, .backgroundOnBoarding2, .backgroundOnBoarding1]
    
    private var viewModel: GalleryViewModelType
    var isLayersGallary = true
    
    // MARK: Init
    
    init(viewModel: GalleryViewModelType = GalleryViewModel()) {
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
        indicitor.startAnimating()
//        segmentedButtonsView.updateButtonsTitles("Layers gallery", "My gallery")
//        segmentedButtonsView.delegate = self
//        if let token = Messaging.messaging().fcmToken {
//            print("Firebase Token: \(token)")
//        }
        collectionViewSetup()
        viewModel.onReloadData = { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.indicitor.stopAnimating()
                self.gallaryCollectionView.reloadData()

                if self.viewModel.photos.isEmpty || !status {
                    self.emptyState.isHidden = false
                    self.gallaryCollectionView.isHidden = true
                } else {
                    self.emptyState.isHidden = true
                    self.gallaryCollectionView.isHidden = false
                }
            }
        }
        bindEmptyStateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPhotos()
    }
}

// MARK: - Configurations

extension GalleryViewController {
    
//    func fetchPhotos() {
//        let allPhotosOptions = PHFetchOptions()
//        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        allPhotos = PHAsset.fetchAssets(with: .image, options: allPhotosOptions)
//        
//        DispatchQueue.main.async {
//            self.gallaryCollectionView.reloadData()
//        }
//    }
    
    func bindEmptyStateView() {
        emptyState.delegate = self
        emptyState.configeView(.empryLikes, String(localized: "yourGalleryIsEmpty"), String(localized: "emptyGalleryMSG") + "!", String(localized: "exploreServices") )
    }
}

// MARK: - Actions

extension GalleryViewController {
    
    func collectionViewSetup() {
        gallaryCollectionView.register(GalleryCollectionViewCell.self)
        gallaryCollectionView.delegate = self
        gallaryCollectionView.dataSource = self
    }
    
    func emptyViewButtonTapped() {
        let vc = ServicesViewController(viewModel: ServicesViewModel(false))
        vc.isProduct = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - CollectionView

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GalleryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if isLayersGallary {
            cell.imageView.kf.setImage(with:URL(string: viewModel.photos[indexPath.item]) )
        }
        else {
//            let asset = allPhotos.object(at: indexPath.item)
//            let width = collectionView.frame.width / 3
//            let cellSize = CGSize(width: width, height: width)
//            let manager = PHImageManager.default()
//            let imageSize = cellSize == .zero ? PHImageManagerMaximumSize : cellSize
//            manager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: nil) { image, _ in
//                cell.imageView.image = image
//            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isLayersGallary {
            return  viewModel.photos.count
        } else {
            return  viewModel.photos.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isLayersGallary {
            let vc = GalleryDetailsViewController()
            vc.pageImage =  viewModel.photos[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
           // getGallerySelectedImage(indexPath.row)
        }
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: width)
    }
}


// MARK: - Private Handlers

private extension GalleryViewController {
    
//    func getGallerySelectedImage(_ index: Int) {
//        let asset = allPhotos.object(at: index)
//        let screenScale = UIScreen.main.scale
//        let viewSize = view.bounds.size
//        let imageSize = CGSize(width: viewSize.width * screenScale, height: viewSize.height * screenScale)
//
//        let manager = PHImageManager.default()
//        let options = PHImageRequestOptions()
//        options.isSynchronous = false
//        options.deliveryMode = .opportunistic
//        options.isNetworkAccessAllowed = true
//
//        manager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { [weak self] image, info in
//            if let isDegraded = info?[PHImageResultIsDegradedKey] as? Bool, !isDegraded {
//                if let image = image {
//                    let destinationVC = GalleryDetailsViewController()
//                    destinationVC.pageImage = image
//                    self?.navigationController?.pushViewController(destinationVC, animated: true)
//                }
//            } else if image == nil {
//                print("Failed to load image")
//            }
//        }
//    }
}

//extension GalleryViewController: SegmantedButtonsDelegation {
//    func firstButtonTapped() {
//        isLayersGallary = true
//        gallaryCollectionView.reloadData()
//    }
//    
//    func secondButtonTapped() {
//        isLayersGallary = false
//        PHPhotoLibrary.requestAuthorization { status in
//            switch status {
//            case .authorized:
//                self.fetchPhotos()
//            case .denied, .restricted, .notDetermined:
//                break
//            case .limited:
//                break
//            @unknown default:
//                break
//            }
//        }
//    }
//    
//}
