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
        
        let helpViewController = TripsListHelpViewController.instantiateFromStoryboard(
            named: R.storyboard.tripsListHelp.name
        )
        
        helpViewController.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.13) {
            self.navController.present(helpViewController, animated: true)
        }
    }
}

// MARK: - Private Helpers
private extension TripsCoordinator {
    
    func presentAddEditTripVC(editing tripToEdit: Trip? = nil) {
        let addEditTripVC = AddEditTripViewController.instantiateFromStoryboard(
            named: R.storyboard.addEditTrip.name
        )
        
        addEditTripVC.delegate = self
        addEditTripVC.modelController = tripsModelController
        addEditTripVC.viewModel = .init(tripToEdit: tripToEdit)
        
        let childNavController = UINavigationController(rootViewController: addEditTripVC)
        navController.present(childNavController, animated: true)
    }
}


// MARK: TripsListViewControllerDelegate
extension TripsCoordinator: TripsListViewControllerDelegate {
    
    func viewController(_ controller: TripsListViewController, didSelectEditingFor trip: Trip) {
        presentAddEditTripVC(editing: trip)
    }
    
    func viewControllerDidSelectAddTrip(_ controller: TripsListViewController) {
        presentAddEditTripVC()
    }
}


// MARK: AddTripViewControllerDelegate
extension TripsCoordinator: AddEditTripViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: AddEditTripViewController) {
        navController.dismiss(animated: true)
    }
    
    
    func viewController(_ controller: AddEditTripViewController, didAdd newTrip: Trip) {
        navController.dismiss(animated: true) 
    }
}
