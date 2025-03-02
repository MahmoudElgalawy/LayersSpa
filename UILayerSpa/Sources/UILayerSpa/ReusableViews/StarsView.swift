//
//  File.swift
//  
//
//  Created by marwa on 11/08/2024.
//

import Cosmos
import Foundation
import UIKit

/// Bridge to access `CosmosView` to avoid coupling in the project
///
public class StarsView: CosmosView {

    public func applyStyleToView() {
        
        settings.updateOnTouch = false
        settings.starSize = 12
        settings.starMargin = 4
        settings.filledImage = .filledStar
        settings.emptyImage = .emptyStar
        
    }

    public func updateStarsRating(_ rate: Double) {
        rating = rate
    }
    
    public func applyEditableStyleToView() {
        rating = 0
        settings.updateOnTouch = true
        settings.starSize = 32
        settings.starMargin = 8
        settings.filledImage = .filledStar
        settings.emptyImage = .emptyStar
        
    }
}

