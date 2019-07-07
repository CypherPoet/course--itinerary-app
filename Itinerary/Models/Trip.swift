//
//  Trip.swift
//  Itinerary
//
//  Created by Brian Sipple on 6/12/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

final class Trip: NSObject {
    let name: String
    
    
    init(name: String) {
        self.name = name
    }
}


extension Trip: Codable {}
