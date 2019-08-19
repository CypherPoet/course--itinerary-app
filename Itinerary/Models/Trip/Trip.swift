//
//  Trip.swift
//  Itinerary
//
//  Created by Brian Sipple on 6/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


struct Trip: HashableFromId {
    typealias RawIdentifier = String
    
    internal let id: Identifier<Trip> = .init(rawValue: UUID().uuidString)
    
    
    var title: String
    var shortDescription: String?
    var primaryImageData: Data?
    var days: [TripDay] = []
}

extension Trip: Codable {}
