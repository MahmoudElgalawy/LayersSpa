//
//  BannersTableViewCell.swift
//  LayersSpa
//
//  Created by marwa on 22/07/2024.
//

import UIKit
import UILayerSpa

class BannersTableViewCell: UITableViewCell, IdentifiableView {
    
    @IBOutlet weak var bannersCollectionView: UICollectionView!
    private let layout = UICollectionViewFlowLayout()
    private var bannerImages: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        collectionViewSetup()
        collectionViewLayout()
    }
    
    
    func collectionViewSetup() {
        bannersCollectionView.register(BannerImagesCollectionViewCell.self)
        bannersCollectionView.delegate = self
        bannersCollectionView.dataSource = self
        DispatchQueue.main.async {
            let middleIndexPath = IndexPath(item: self.bannerImages.count / 2, section: 0)
            self.bannersCollectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    func collectionViewLayout() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12 // Space between rows
        layout.minimumInteritemSpacing = 8 // Space between columns
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // Padding around the section
        bannersCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bannersCollectionView.collectionViewLayout = layout
    }
    
    func configureCell(_ bannersImages: [UIImage]) {
        self.bannerImages = bannersImages
    }
}

extension BannersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BannerImagesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(bannerImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height // Make the cell height the same as the collection view height
        let width: CGFloat = 328 //height - layout.sectionInset.left - layout.sectionInset.right // Adjust width as needed, here it's set to height for a square cell
        return CGSize(width: width, height: height)
    }
    
}


