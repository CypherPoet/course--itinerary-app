//
//  Endpoint.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


enum Endpoint {
    
    enum Trip {
        static let localURL = FileManager
            .userDocumentsDirectory
            .appendingPathComponent("trips", isDirectory: false)
            .appendingPathExtension("json")
    }
    
}
