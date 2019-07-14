//
//  TripTableViewCell+ViewModel.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/13/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


extension TripTableViewCell {
    
    struct ViewModel {
        var title: String
        var subtitle: String
    }
}


// MARK: - Computeds

extension TripTableViewCell.ViewModel {
    
    var titleText: String { title }
    var subtitleText: String { subtitle }
}
