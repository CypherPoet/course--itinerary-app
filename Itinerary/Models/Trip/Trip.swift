//
//  Trip.swift
//  Itinerary
//
//  Created by Brian Sipple on 6/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


struct Trip: Identifiable {
    typealias RawIdentifier = String
    
    internal let id: Identifier<Trip> = .init(rawValue: UUID().uuidString)
    var title: String
    var shortDescription: String?
    var primaryImageData: Data?
}


// MARK: - Hashable
extension Trip: Hashable {
    func combine(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension Trip: Codable {}
