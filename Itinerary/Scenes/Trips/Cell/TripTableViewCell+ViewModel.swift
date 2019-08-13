//
//  TripTableViewCell+ViewModel.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


extension TripTableViewCell {
    
    struct ViewModel {
        var title: String
        var subtitle: String?
        var primaryImage: UIImage?
    }
}


// MARK: - Computeds

extension TripTableViewCell.ViewModel {
    
    var titleText: String { title }
    var subtitleText: String? { subtitle }
}
