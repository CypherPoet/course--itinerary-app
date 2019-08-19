//
//  TripDay.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct TripDay: HashableFromId {
    typealias RawIdentifier = String
    
    internal let id: Identifier<TripDay> = .init(rawValue: UUID().uuidString)
    
    
    var date: Date
    var subtitle: String
    var activities: [TripActivity]
}


extension TripDay: Codable {}
