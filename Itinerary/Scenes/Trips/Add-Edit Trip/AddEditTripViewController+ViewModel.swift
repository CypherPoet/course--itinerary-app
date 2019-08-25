//
//  AddEditTripViewController+ViewModel.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/14/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import Foundation


extension AddEditTripViewController {
    
    struct ViewModel {
        var tripToEdit: Trip?
    }
}


// MARK: -  Computeds
extension AddEditTripViewController.ViewModel {
    
    var mainTitleText: String {
        tripToEdit != nil ? "Edit Your Trip" : "Add a New Trip"
    }
}
