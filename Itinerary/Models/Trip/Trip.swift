//
//  Trip.swift
//  Itinerary
//
//  Created by Brian Sipple on 6/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct Trip: Identifiable {
    typealias RawIdentifier = String
    
    let id: Identifier<Trip> = .init(rawValue: UUID().uuidString)
    let title: String
}


extension Trip: Codable {}
