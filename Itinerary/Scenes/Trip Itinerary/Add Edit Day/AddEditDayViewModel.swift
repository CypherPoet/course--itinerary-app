//
//  AddEditDayViewModel.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/22/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


struct AddEditDayViewModel {
    var subtitle: String?
    var dateForDay = Date()
}


extension AddEditDayViewModel {
    var minimumDate: Date { Date() }
}
