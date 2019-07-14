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
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
}


// MARK: - Coordinator

extension TripsCoordinator: Coordinator {
    
    func start() {
        let tripsListVC = TripsListViewController.instantiateFromStoryboard(
            named: R.storyboard.trips.name
        )
       
        tripsListVC.title = "My Trips"
        tripsListVC.modelController = TripsModelController()
        
        navController.pushViewController(tripsListVC, animated: true)
    }
    
}
