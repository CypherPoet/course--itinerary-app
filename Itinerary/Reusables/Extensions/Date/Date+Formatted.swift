//
//  Date+Formatted.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/23/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

extension Date {

    var formattedDay: String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter.string(from: self)
    }
}
