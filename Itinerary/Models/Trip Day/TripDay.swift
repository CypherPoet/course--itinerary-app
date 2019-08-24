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


extension TripDay {
    private var dateComponents: DateComponents {
        Calendar.current.dateComponents([.day, .month, .year], from: date)
    }
    
    var day: Int? { dateComponents.day }
    var month: Int? { dateComponents.month }
    var year: Int? { dateComponents.year }
}


extension TripDay {
    func isOnSameDay(as otherDay: TripDay) -> Bool {
        (day, month, year) == (otherDay.day, otherDay.month, otherDay.year)
    }
    
    func isOnDifferentDay(than otherDay: TripDay) -> Bool {
        (day, month, year) != (otherDay.day, otherDay.month, otherDay.year)
    }
}

extension TripDay: Codable {}
