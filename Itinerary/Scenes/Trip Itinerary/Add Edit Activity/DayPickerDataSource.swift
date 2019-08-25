//
//  DayPickerDataSource.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/24/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


final class DayPickerDataSource: NSObject, UIPickerViewDataSource {
    let days: [TripDay]
    
    
    init(days: [TripDay]) {
        self.days = days
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        days.count
    }
}
