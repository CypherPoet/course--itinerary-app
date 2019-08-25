//
//  AddEditActivityViewModel.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation

struct AddEditActivityViewModel {
    var activityTitle: String?
    var activitySubtitle: String?
    var selectedDay: TripDay?
    var selectedType: TripActivityType?
    
    var availableDays: [TripDay]
    var availableActivityTypes: [TripActivityType]
}


extension AddEditActivityViewModel {
    var selectedDayIndex: Int? {
        guard let selectedDay = selectedDay else { return nil }
        return availableDays.firstIndex(of: selectedDay)
    }
}
