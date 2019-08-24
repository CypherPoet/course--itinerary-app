//
//  TripItineraryCoordinator.swift
//  Itinerary
//
//  Created by Brian Sipple on 8/17/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


protocol TripItineraryCoordinatorDelegate: class {

    func coordinator(
        _ coordinator: TripItineraryCoordinator,
        didAdd newDay: TripDay,
        to trip: Trip,
        then completionHandler: @escaping ((Result<Trip, Error>) -> Void)
    )
}


final class TripItineraryCoordinator: NavigationCoordinator {
    var navController: UINavigationController
    
    var modelController: TripActivitiesModelController
    

    var tripActivitiesViewController: TripActivitiesViewController!
    weak var delegate: TripItineraryCoordinatorDelegate?
    
    
    init(
        modelController: TripActivitiesModelController,
        navController: UINavigationController,
        delegate: TripItineraryCoordinatorDelegate?
    ) {
        self.modelController = modelController
        self.navController = navController
        self.delegate = delegate
    }
}


// MARK: - Computeds
extension TripItineraryCoordinator {
    var trip: Trip { modelController.trip }
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
        tripActivitiesViewController = TripActivitiesViewController.instantiate(
            viewModel: TripActivitiesViewModel(),
            tripDays: trip.days,
            delegate: self
        )
        
        tripActivitiesViewController.title = trip.title
        tripActivitiesViewController.navigationItem.largeTitleDisplayMode = .never
        
        navController.pushViewController(tripActivitiesViewController, animated: true)
    }
}


// MARK: - TripActivitiesViewControllerDelegate
extension TripItineraryCoordinator: TripActivitiesViewControllerDelegate {

    func viewControllerDidSelectNewDay(_ controller: TripActivitiesViewController) {
        let newDayVC = AddEditDayViewController.instantiate(
            viewModel: AddEditDayViewModel(),
            delegate: self
        )
        
        newDayVC.title = trip.title
        
        let childNavController = UINavigationController(rootViewController: newDayVC)
        
        Appearance.apply(to: childNavController.navigationBar)
        navController.present(childNavController, animated: true)
    }
    
    
    func viewControllerDidSelectNewActivities(_ controller: TripActivitiesViewController) {
        // TODO: Implement
    }
}


// MARK: - AddEditDayViewControllerDelegate
extension TripItineraryCoordinator: AddEditDayViewControllerDelegate {
    
    func viewControllerDidCancel(_ controller: AddEditDayViewController) {
        navController.dismiss(animated: true)
    }
    
    func viewController(_ controller: AddEditDayViewController, didAdd newDay: TripDay) {
        navController.dismiss(animated: true)
  
        delegate?.coordinator(self, didAdd: newDay, to: trip) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let newTrip):
                self.modelController.trip = newTrip
                self.tripActivitiesViewController.tripDays = self.modelController.sortedDays
            case .failure(let error):
                let alertMessage: String
                
                if case TripsModelController.TripsModelControllerError.dayConflict = error {
                    alertMessage = "This trip already has a day created for \(newDay.date.formattedDay)"
                } else {
                    alertMessage = "An error occurred while trying to add a new day. Please try again."
                }
                
                self.navController.display(alertMessage: alertMessage)
            }
        }
    }
    
    
}
