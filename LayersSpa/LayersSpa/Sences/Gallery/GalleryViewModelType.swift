//  
//  GalleryViewModelType.swift
//  LayersSpa
//
//  Created by marwa on 23/07/2024.
//

import Foundation
import UIKit

/// Gallery Input & Output
///
typealias GalleryViewModelType = GalleryViewModelInput & GalleryViewModelOutput

/// Gallery ViewModel Input
///
protocol GalleryViewModelInput {
    func fetchPhotos()
}

/// Gallery ViewModel Output
///
protocol GalleryViewModelOutput {
   // func getPhotosNum() -> Int
    var onReloadData: ((Bool) -> Void) { get set }
    var photos: [String] { get set}
   // func getPhoto(_ index: Int) -> UIImage?
}
