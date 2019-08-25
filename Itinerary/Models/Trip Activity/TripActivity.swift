//
//  TripActivity.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


struct TripActivity: HashableFromId {
    typealias RawIdentifier = String
    
    internal let id: Identifier<TripActivity> = .init(rawValue: UUID().uuidString)
    
    
    var title: String
    var subtitle: String
    var activityType: TripActivityType
    var photoData: Data?
}


extension TripActivity: Comparable {
    
    // 🔑 A better solution would be to support specific times for
    // activities and sort on those.
    // This is a cool exercise, though 😛
    static func < (lhs: TripActivity, rhs: TripActivity) -> Bool {
        lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
    }
}


extension TripActivity: Codable {}
