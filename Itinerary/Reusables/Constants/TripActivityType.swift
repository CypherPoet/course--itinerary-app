//
//  TripActivityType.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


enum TripActivityType: String {
    case flight
    case groundTransport
    case lodging
    case food
    case exploration
}


extension TripActivityType {
    
    var iconImage: UIImage? {
        switch self {
        case .flight:
            return UIImage(systemName: "airplane")
        case .groundTransport:
            return UIImage(systemName: "car.fill")
        case .lodging:
            return UIImage(systemName: "house.fill")
        case .food:
            return UIImage(systemName: "airplane")
        case .exploration:
            return UIImage(systemName: "map.fill")
        }
    }
}


extension TripActivityType: Codable {}
