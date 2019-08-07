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
    lazy var tripsModelController = TripsModelController()

    
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
       
        tripsListVC.delegate = self
        tripsListVC.navigationItem.title = "My Trips"
        tripsListVC.modelController = tripsModelController
        
        navController.navigationBar.prefersLargeTitles = true
        
        navController.setViewControllers([tripsListVC], animated: true)
    }
}


// MARK: TripsListViewControllerDelegate
extension TripsCoordinator: TripsListViewControllerDelegate {

    func viewControllerDidSelectAddTrip(_ controller: TripsListViewController) {
        let addTripVC = AddTripViewController.instantiateFromStoryboard(
            named: R.storyboard.addTrip.name
        )
        
        addTripVC.delegate = self
        addTripVC.modelController = tripsModelController
        
        let childNavController = UINavigationController(rootViewController: addTripVC)
        childNavController.modalTransitionStyle = .coverVertical
        childNavController.modalPresentationStyle = .pageSheet
        
        navController.present(childNavController, animated: true)
    }
}


// MARK: AddTripViewControllerDelegate
extension TripsCoordinator: AddTripViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: AddTripViewController) {
        navController.dismiss(animated: true)
    }
    
    
    func viewController(_ controller: AddTripViewController, didAdd newTrip: Trip) {
        navController.dismiss(animated: true) 
    }
}
