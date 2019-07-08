//
//  TripsCoordinator.swift
//  Itinerary
//
//  Created by Brian Sipple on 7/7/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

final class TripsCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    private let modelController: TripsModelController
    
    
    init(
        navController: UINavigationController
    ) {
        self.navController = navController
        self.modelController = TripsModelController()
    }
}


// MARK: - Coordinator

extension TripsCoordinator: Coordinator {
    
    func start() {
        let tripsListVC = TripsListViewController.instantiateFromStoryboard(
            named: R.storyboard.trips.name
        )
       
        tripsListVC.title = "My Trips"
        navController.pushViewController(tripsListVC, animated: true)
        

        modelController.loadTrips { (dataResult) in
            let dummyTrips = [
                Trip(title: "Trip to NYC"),
                Trip(title: "Trip to Chicago"),
                Trip(title: "Trip to London"),
                Trip(title: "Trip to Paris"),
            ]
            
            tripsListVC.trips = dummyTrips
            
            // TODO: Use real results instead of dummy data
//            switch dataResult {
//            case .success(let trips):
//                tripsListVC.trips = trips
//            case .failure:
//                tripsListVC.trips = []
//            }
        }
    }
    
}
