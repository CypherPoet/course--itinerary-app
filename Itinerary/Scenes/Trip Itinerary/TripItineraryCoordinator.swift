//
//  TripItineraryCoordinator.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


final class TripItineraryCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    let trip: Trip
    
    
    init(
        trip: Trip,
        navController: UINavigationController
    ) {
        self.trip = trip
        self.navController = navController
    }
}


// MARK: - Coordinator
extension TripItineraryCoordinator: Coordinator {
    
    func start() {
        showActivitiesView()
    }
}

// MARK: - Private Helpers
private extension TripItineraryCoordinator {
  
    func showActivitiesView() {
        let tripActivitiesViewController = TripActivitiesViewController.instantiateFromStoryboard(
            named: R.storyboard.tripItinerary.name
        )
        
        tripActivitiesViewController.viewModel = TripActivitiesViewModel(
            
        )
        
        tripActivitiesViewController.modelController = TripActivitiesModelController(
            days: trip.days
        )
        
//        tripActivitiesViewController.delegate = self
        
        navController.pushViewController(tripActivitiesViewController, animated: true)
    }
}

//
//// MARK: TripActivitiesViewControllerDelegate
//extension TripItineraryCoordinator: TripActivitiesViewControllerDelegate {
//
//}

