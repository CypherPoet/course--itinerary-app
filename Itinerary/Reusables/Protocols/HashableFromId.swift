//
//  HashableFromId.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


protocol HashableFromId: Identifiable, Hashable {}


extension HashableFromId where Self.RawIdentifier: Hashable {

    func combine(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
