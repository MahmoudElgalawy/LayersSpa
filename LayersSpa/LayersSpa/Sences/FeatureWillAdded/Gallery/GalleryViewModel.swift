//  
//  GalleryViewModel.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import Foundation
import Photos
import UIKit

// MARK: GalleryViewModel

class GalleryViewModel {
    var allPhotos: PHFetchResult<PHAsset> = PHFetchResult()
    var onReloadData: (() -> Void) = { }
}

// MARK: GalleryViewModel

extension GalleryViewModel: GalleryViewModelInput {
    
    func getPhotosNum() -> Int {
        return allPhotos.count
    }
    
    func getPhoto(_ index: Int) -> UIImage? {
        var photo: UIImage?
        let asset = allPhotos.object(at: index)
        let manager = PHImageManager.default()
        let imageSize = CGSize(width: 100, height: 100)
        
        manager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: nil) { image, _ in
            photo = image
        }
        
        return photo
    }
   
}

// MARK: GalleryViewModelOutput

extension GalleryViewModel: GalleryViewModelOutput {
    func fetchPhotos() {
           let fetchOptions = PHFetchOptions()
           fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
           let fetchedPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
           allPhotos = fetchedPhotos
           onReloadData()
       }
}

// MARK: Private Handlers

private extension GalleryViewModel {

}
