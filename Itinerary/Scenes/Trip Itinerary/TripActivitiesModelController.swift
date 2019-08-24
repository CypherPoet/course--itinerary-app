//
//  TripActivitiesModelController.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


final class TripActivitiesModelController {
    
    var trip: Trip {
        didSet { sortedDays = getSortedDays() }
    }
    
    private(set) var sortedDays: [TripDay] = []
    
    
    init(trip: Trip) {
        self.trip = trip
        self.sortedDays = getSortedDays()
    }
}


private extension TripActivitiesModelController {
    
    func getSortedDays() -> [TripDay] {
        trip.days.sorted { $0.date < $1.date }
    }
}
